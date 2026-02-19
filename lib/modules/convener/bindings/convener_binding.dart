import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/convener/controllers/convener_controller.dart';
import 'package:gurukul_bhutpurva/modules/convener/controllers/groups_controller.dart';

class ConvenerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConvenerController>(() => ConvenerController());
    Get.lazyPut<GroupsController>(() => GroupsController());
  }
}
