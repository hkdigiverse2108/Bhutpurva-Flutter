import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/home/controllers/home_controller.dart';
import 'package:gurukul_bhutpurva/modules/menu/controllers/menu_controller.dart';
import 'package:gurukul_bhutpurva/modules/profile/controllers/profile_controller.dart';
import '../controllers/navigation_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<MenusController>(() => MenusController());
  }
}
