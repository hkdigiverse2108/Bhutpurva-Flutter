import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/life_light/controllers/life_light_controller.dart';
import 'package:gurukul_bhutpurva/modules/life_light/controllers/status_controller.dart';

class LifeLightBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LifeLightController>(() => LifeLightController());
    Get.lazyPut<StatusController>(() => StatusController());
  }
}
