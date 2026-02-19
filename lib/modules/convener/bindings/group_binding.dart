import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/convener/controllers/group_details_controller.dart';

class GroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupDetailsController>(() => GroupDetailsController());
  }
}
