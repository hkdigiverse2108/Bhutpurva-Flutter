import 'package:get/get.dart';

class NavigationController extends GetxController {
  /// current selected index
  final RxInt currentIndex = 0.obs;

  /// change tab
  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
