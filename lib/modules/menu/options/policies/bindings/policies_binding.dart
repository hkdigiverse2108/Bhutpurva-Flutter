import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/menu/options/policies/controllers/policies_controller.dart';

class PoliciesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PoliciesController>(() => PoliciesController());
  }
}
