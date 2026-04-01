import 'dart:developer';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/data/models/banner/banner_model.dart';
import 'package:gurukul_bhutpurva/data/models/settings/settings_model.dart';
import 'package:gurukul_bhutpurva/shared/global/global_ver.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';

class HomeController extends GetxController {
  final isLoading = true.obs;
  final isLeader = false.obs;
  final isBanner = false.obs;

  final apiService = ApiService.to;
  final storageService = Get.find<StorageService>();

  late String userBatchId;

  @override
  void onInit() {
    super.onInit();
    isLeader.value = storageService.isLeader;
    log(isLeader.value.toString());
    isLoading.value = false;
    loadSettings();
    getBanners();
  }

  final banners = <BannerModel>[].obs;

  void getBanners() async {
    try {
      isBanner.value = true;
      final response = await apiService.get(ApiConstants.banners);
      if (response.status == 200) {
        banners.value = (response.data as List<dynamic>)
            .map((e) => BannerModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      AppSnackbar.error("Something went wrong");
    } finally {
      isBanner.value = false;
    }
  }

  void loadSettings() async {
    try {
      isLoading.value = true;
      final response = await apiService.get(ApiConstants.settings);
      if (response.status == 200) {
        final settings = SettingsModel.fromJson(response.data['setting']);
        storageService.saveSettings(settings);
        globalSettings = settings;
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToAssigned() {
    if (storageService.user.batchId != null) {
      Get.toNamed(
        AppRoutes.batchDetails,
        arguments: storageService.user.batchId,
      );
    } else {
      AppSnackbar.error("You are not assigned to any batch");
    }
  }
}
