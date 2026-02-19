import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';

class ClassModel {
  final Rx<ClassStatus> isInGurukul = ClassStatus.notSelected.obs;
  final Rx<String?> branch = ''.obs;
  final Rx<String?> passingYear = ''.obs;
  final Rx<String?> medium = ''.obs;
  final Rx<String?> hostel = ''.obs;

  ClassModel({ClassStatus isInGurukulValue = ClassStatus.notSelected});
}
