import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:gurukul_bhutpurva/shared/global/global_ver.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';

class AnubhutiController extends GetxController {
  final Rx<String?> anubhutiImage = globalSettings?.anubhutiImage.obs ?? "".obs;

  final TextEditingController anubhutiController = TextEditingController();

  final RxBool isLoading = false.obs;
  final apiService = ApiService.to;

  @override
  void onInit() {
    super.onInit();
    anubhutiImage.value = globalSettings?.anubhutiImage;
  }

  void sendAnubhuti() async {
    final text = anubhutiController.text.trim();
    if (text.isEmpty) {
      AppSnackbar.error("Please write your experience first");
      return;
    }

    try {
      isLoading.value = true;
      final ResModel res = await apiService.post(
        ApiConstants.sendAnubhuti,
        body: {"anubhuti": text},
      );

      if (res.status == 200 || res.status == 201) {
        anubhutiController.clear();
        AppSnackbar.success("Your experience has been sent successfully!");
        Get.back();
      } else {
        AppSnackbar.error(res.message ?? "Something went wrong");
      }
    } catch (e) {
      log(e.toString());
      AppSnackbar.error("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
