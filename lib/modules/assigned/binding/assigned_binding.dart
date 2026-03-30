import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/assigned/controllers/assigned_controller.dart';
class AssignedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssignedController>(() => AssignedController());
  }
}
