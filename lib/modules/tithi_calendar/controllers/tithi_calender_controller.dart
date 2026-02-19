import 'package:get/get.dart';

class TithiCalenderController extends GetxController {
  final months = const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// 0 = January
  final selectedMonthIndex = DateTime.now().month.obs..value -= 1;

  /// Example image mapping (replace with API later)
  final monthImages = <int, String>{
    0: 'assets/tithi/january.png',
    1: 'assets/tithi/february.png',
    2: 'assets/tithi/march.png',
    3: 'assets/tithi/april.png',
    4: 'assets/tithi/may.png',
    5: 'assets/tithi/june.png',
    6: 'assets/tithi/july.png',
    7: 'assets/tithi/august.png',
    8: 'assets/tithi/september.png',
    9: 'assets/tithi/october.png',
    10: 'assets/tithi/november.png',
    11: 'assets/tithi/december.png',
  };

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
