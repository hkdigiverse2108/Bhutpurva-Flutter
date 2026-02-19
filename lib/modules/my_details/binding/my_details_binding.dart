import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/my_details/controllers/my_details_controller.dart';

class MyDetailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyDetailsController>(() => MyDetailsController());
  }
}
