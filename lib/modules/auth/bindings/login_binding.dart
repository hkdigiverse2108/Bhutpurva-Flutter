import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/auth/controllers/login_controller.dart';
import 'package:gurukul_bhutpurva/modules/auth/controllers/otp_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<OtpController>(() => OtpController());
  }
}
