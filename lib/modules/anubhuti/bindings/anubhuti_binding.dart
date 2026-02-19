import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/anubhuti/controllers/anubhuti_controller.dart';

class AnubhutiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnubhutiController>(() => AnubhutiController());
  }
}
