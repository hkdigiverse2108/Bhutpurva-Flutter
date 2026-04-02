import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';

class ClassModel {
  final Rx<ClassStatus> isInGurukul = ClassStatus.notSelected.obs;
  final RxnString branch = RxnString();
  final RxnString passingYear = RxnString();
  final RxnString medium = RxnString();
  final RxnString hostel = RxnString();

  ClassModel({ClassStatus isInGurukulValue = ClassStatus.notSelected}) {
    isInGurukul.value = isInGurukulValue;
  }
}
