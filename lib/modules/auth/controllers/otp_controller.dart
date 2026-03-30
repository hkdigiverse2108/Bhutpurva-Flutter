import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart' show AppRoutes;
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:gurukul_bhutpurva/data/models/verification/verification_model.dart';

class OtpController extends GetxController {
  final isLoading = false.obs;

  final phoneNumber = "".obs;

  @override
  void onInit() {
    super.onInit();
    phoneNumber.value = Get.arguments;
  }

  final otpController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final apiService = ApiService();
  final storageService = Get.find<StorageService>();

  String? validateOtp(value) {
    if (value!.isEmpty) {
      return 'OTP is required';
    }
    if (value.length < 6) {
      return 'OTP must be at least 6 digits';
    }
    return null;
  }

  void verifyOtp() async {
    FocusScope.of(Get.context!).unfocus();
    bool navigated = false;
    try {
      isLoading.value = true;
      if (formKey.currentState!.validate()) {
        ResModel response = await apiService.post(
          ApiConstants.verifyOtp,
          body: {'phoneNumber': phoneNumber.value, 'otp': otpController.text},
        );

        if (response.status == 200) {
          // Offload parsing to background thread
          log('Starting compute...');
          final VerificationModel data = await compute(
            _parseVerificationModel,
            response.data,
          );
          log('Compute finished. Data parsed.');

          await storageService.saveToken(data.token);
          log('Token saved to storage.');

          try {
            await storageService.saveUser(data.user);
            log('User saved to storage.');
          } catch (e) {
            log('FAILED to save user: $e');
          }

          await storageService.saveProfileType(
            data.user.role ?? ProfileType.user,
          );
          log('Profile type saved.');

          // Add to multi-profile list
          final profileIndex = await storageService.addProfile(
            data.token,
            data.user,
          );
          await storageService.write(
            'active_profile_index',
            profileIndex,
          );
          log('Profile added to local list at index $profileIndex.');

          storageService.isLoggedIn = true;
          log('isLoggedIn set.');

          navigated = true;
          log('Navigating to Home...');
          Get.offAllNamed(AppRoutes.navigation);
        }
      }
    } catch (e) {
      log(e.toString());
    } finally {
      if (!navigated) isLoading.value = false;
    }
  }
}

/// Top-level function for compute
VerificationModel _parseVerificationModel(dynamic data) {
  return VerificationModel.fromJson(data);
}
