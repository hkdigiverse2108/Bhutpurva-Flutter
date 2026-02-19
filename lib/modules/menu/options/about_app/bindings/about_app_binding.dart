import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/menu/options/about_app/controllers/about_app_controller.dart';

class AboutAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutAppController>(() => AboutAppController());
  }
}
