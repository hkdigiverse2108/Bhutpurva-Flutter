import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/menu/options/technical_support/controllers/technical_support_controller.dart';

class TechnicalSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TechnicalSupportController>(() => TechnicalSupportController());
  }
}
