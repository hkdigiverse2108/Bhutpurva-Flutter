import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/tithi_calendar/controllers/tithi_calender_controller.dart';

class TithiCalenderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TithiCalenderController>(() => TithiCalenderController());
  }
}
