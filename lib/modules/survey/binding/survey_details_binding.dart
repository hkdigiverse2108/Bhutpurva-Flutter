import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/survey/controllers/survey_details_controller.dart';

class SurveyDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SurveyDetailsController>(() => SurveyDetailsController());
  }
}
