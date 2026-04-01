import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiService());
  }
}
