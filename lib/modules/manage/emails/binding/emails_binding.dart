import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/manage/emails/controllers/emails_controller.dart';

class EmailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailsController>(() => EmailsController());
  }
}
