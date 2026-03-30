import 'dart:developer';

import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/data/models/tithi_calender/tithi_calender_model.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';

class TithiCalenderController extends GetxController {
  var tithiCalender = Rx<TithiCalenderModel?>(null);

  var isLoading = false.obs;
  final apiService = ApiService();

  /// 0 = January
  final selectedMonthIndex = DateTime.now().month.obs..value -= 1;

  @override
  void onInit() {
    super.onInit();
    fetchCalendar();
  }

  Future<void> fetchCalendar() async {
    try {
      isLoading(true);

      final year = DateTime.now().year;
      final res = await apiService.get(ApiConstants.tithiCalendar(year: year));

      if (res.status == 200 &&
          res.data != null &&
          res.data is Map<String, dynamic> &&
          res.data['tithiCalender'] != null) {
        tithiCalender.value = TithiCalenderModel.fromJson(
          res.data['tithiCalender'] as Map<String, dynamic>,
        );
      } else {
        AppSnackbar.error('Calendar not found');
      }
    } catch (e) {
      log(e.toString());
      AppSnackbar.error('Something went wrong');
    } finally {
      isLoading(false);
    }
  }

  void nextMonth() {
    if (selectedMonthIndex.value < 11) {
      selectedMonthIndex.value++;
    } else {
      selectedMonthIndex.value = 0;
    }
  }

  void prevMonth() {
    if (selectedMonthIndex.value > 0) {
      selectedMonthIndex.value--;
    } else {
      selectedMonthIndex.value = 11;
    }
  }

  void selectMonth(int index) {
    selectedMonthIndex.value = index;
  }
}
