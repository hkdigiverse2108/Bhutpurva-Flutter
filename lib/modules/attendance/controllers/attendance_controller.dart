import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/data/models/attendance/attendance_model.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';

class AttendanceController extends GetxController {
  final apiSirvices = ApiService();
  final StorageService storage = Get.find();

  final isLoading = false.obs;
  final List<AttendanceModel> attendance = <AttendanceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAttendance();
  }

  void getAttendance() async {
    try {
      isLoading.value = true;
      final ResModel res = await apiSirvices.get(
        ApiConstants.getAttendanceById(storage.user.id ?? ""),
      );
      if (res.status == 200) {
        // res.data.forEach((element) {
        //   attendance.add(AttendanceModel.fromJson(element));
        // });
      }
    } catch (e) {
      AppSnackbar.error('Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }
}
