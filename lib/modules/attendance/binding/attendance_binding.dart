import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/attendance/controllers/attendance_controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceController>(() => AttendanceController());
  }
}
