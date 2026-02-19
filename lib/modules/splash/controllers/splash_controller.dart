import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';

class SplashController extends GetxController {
  final storage = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () {
      if (storage.isLoggedIn) {
        navigateToHome();
      } else {
        navigateToLogin();
      }
    });
  }

  navigateToLogin() {
    Get.offNamed(AppRoutes.login);
  }

  navigateToHome() {
    Get.offNamed(AppRoutes.navigation);
  }
}
