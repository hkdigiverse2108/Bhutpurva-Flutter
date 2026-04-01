import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/data/models/attendance/attendance_model.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';
import 'package:intl/intl.dart';

class AttendanceController extends GetxController {
  final apiSirvices = ApiService();
  final StorageService storage = Get.find();

  final isLoading = false.obs;
  final List<SAttendanceModel> attendance = <SAttendanceModel>[].obs;

  int get total => attendance.length;
  int get presentCount => attendance.where((a) => a.isPresent).length;
  int get absentCount => attendance.where((a) => !a.isPresent).length;

  double get attendancePercentage {
    if (attendance.isEmpty) return 0.0;
    return (presentCount / total) * 100;
  }

  Map<String, List<SAttendanceModel>> get groupedAttendance {
    final Map<String, List<SAttendanceModel>> groups = {};
    for (var record in attendance) {
      final dateKey = DateFormat('yyyy-MM-dd').format(record.date);
      if (!groups.containsKey(dateKey)) {
        groups[dateKey] = [];
      }
      groups[dateKey]!.add(record);
    }
    return groups;
  }

  void getAttendance() async {
    try {
      isLoading.value = true;
      final ResModel res = await apiSirvices.get(
        ApiConstants.getAttendanceById(storage.user.id ?? ""),
      );
      if (res.status == 200) {
        attendance.clear();
        res.data.forEach((element) {
          attendance.add(SAttendanceModel.fromJson(element));
        });
      }
    } catch (e) {
      AppSnackbar.error('Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }
}
