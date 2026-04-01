import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/core/services/auth_service.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final apiService = ApiService.to;

  void navigateToPhone() {
    Get.toNamed(AppRoutes.phoneLogin);
  }

  void getOTP() async {
    FocusScope.of(Get.context!).unfocus();
    try {
      if (formKey.currentState?.validate() ?? false) {
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

  Future<void> loginWithGoogle() async {
    try {
      isGoogleLoading.value = true;
      final authService = AuthService();
      final GoogleSignInAccount? googleUser = await authService
          .signInWithGoogle();

      if (googleUser == null) {
        isGoogleLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        AppSnackbar.error("Failed to get Google ID Token");
        isGoogleLoading.value = false;
        return;
      }

      ResModel response = await apiService.post(
        ApiConstants.google,
        body: {'idToken': idToken},
      );

      if (response.status == 200 || response.status == 201) {
        final storageService = Get.find<StorageService>();
        storageService.saveToken(response.data['token'] ?? "");
        storageService.saveProfileType(
          ProfileType.leader,
        ); // Defaulting to leader for now
        Get.offAllNamed(AppRoutes.navigation);
        AppSnackbar.success("Logged in successfully with Google");
      } else {
        AppSnackbar.error(response.message ?? "Google Login failed");
      }
    } catch (e) {
      log("Login with Google Error: $e");
      AppSnackbar.error("Something went wrong with Google Login");
    } finally {
      isGoogleLoading.value = false;
    }
  }
}
