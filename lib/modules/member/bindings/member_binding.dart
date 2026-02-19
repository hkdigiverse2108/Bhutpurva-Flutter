import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/member/controllers/member_update_controller.dart';

class MemberBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MemberUpdateController>(() => MemberUpdateController());
  }
}
