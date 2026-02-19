import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/menu/controllers/menu_controller.dart';

class MenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenusController>(() => MenusController());
  }
}
