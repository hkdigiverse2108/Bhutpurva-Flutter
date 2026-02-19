import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/assigned/controllers/program_details_controller.dart';
import 'package:gurukul_bhutpurva/modules/assigned/controllers/programs_controller.dart';

class ProgramBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProgramsController>(() => ProgramsController());
    Get.lazyPut<ProgramDetailsController>(() => ProgramDetailsController());
  }
}
