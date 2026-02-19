import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/auth/controllers/switch_profile_controller.dart';

class SwitchProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SwitchProfileController>(() => SwitchProfileController());
  }
}
