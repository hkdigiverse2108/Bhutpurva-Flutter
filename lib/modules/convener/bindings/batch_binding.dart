import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/convener/controllers/batch_details_controller.dart';

class BatchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BatchDetailsController>(() => BatchDetailsController());
  }
}
