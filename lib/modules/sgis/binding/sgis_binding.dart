import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/sgis/controllers/sgis_controller.dart';

class SgisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SgisController>(() => SgisController());
  }
}
