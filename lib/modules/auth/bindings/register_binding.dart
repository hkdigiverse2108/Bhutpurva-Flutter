import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/auth/controllers/register_controller.dart';

class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}
