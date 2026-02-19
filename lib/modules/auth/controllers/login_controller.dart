import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final apiService = ApiService();

  void navigateToPhone() {
    Get.toNamed(AppRoutes.phoneLogin);
  }

  void getOTP() async {
    FocusScope.of(Get.context!).unfocus();
    try {
      if (formKey.currentState!.validate()) {
        isLoading.value = true;
        ResModel response = await apiService.post(
          ApiConstants.sendOtp,
          body: {'phoneNumber': phoneController.text},
        );

        if (response.status == 200) {
          Get.toNamed(AppRoutes.otp, arguments: phoneController.text);
        }
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToNavigation() {
    final storageService = Get.find<StorageService>();
    storageService.saveToken("token");
    storageService.saveProfileType(ProfileType.leader);
    Get.toNamed(AppRoutes.navigation);
  }

  void navigateToRegister() {
    Get.toNamed(AppRoutes.register);
  }
}
