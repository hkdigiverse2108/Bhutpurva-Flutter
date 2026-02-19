import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/survey/controllers/survey_controller.dart';

class SurveyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SurveyController>(() => SurveyController());
  }
}
