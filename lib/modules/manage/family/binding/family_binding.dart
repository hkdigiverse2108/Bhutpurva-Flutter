import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/manage/family/controllers/family_controller.dart';

class FamilyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FamilyController>(() => FamilyController());
  }
}
