import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/data/models/class/class_model.dart';

class MyDetailsController extends GetxController {
  final majorDetailsFormKey = GlobalKey<FormState>();
  final classDetailsFormKey = GlobalKey<FormState>();

  final tab = 0.obs;

  // Major Details
  final hrNoController = TextEditingController(text: 'Major HR No');
  final currentCity = 'select'.obs;
  final area = 'select'.obs;
  final tenTh = ClassModel().obs;
  final twelveTh = ClassModel().obs;
  final studyField = 'Not Selected'.obs;

  // Class Details
  final class1 = ClassModel().obs;
  final class2 = ClassModel().obs;
  final class3 = ClassModel().obs;
  final class4 = ClassModel().obs;
  final class5 = ClassModel().obs;
  final class6 = ClassModel().obs;
  final class7 = ClassModel().obs;
  final class8 = ClassModel().obs;
  final class9 = ClassModel().obs;
  final class10 = ClassModel().obs;
  final class11 = ClassModel().obs;
  final class12 = ClassModel().obs;

  final branch = [
    'surat Gurukul',
    'bharuch Gurukul',
    'jasdan Gurukul',
    'una Gurukul',
    'new delhi Gurukul',
  ].obs;

  final currentCityList = <String>['select', 'surat', 'other'].obs;

  late final List<String> passingYears;
  late final List<String> hostels = [
    'not Selected',
    'hostel',
    'non hostel',
  ].obs;

  @override
  void onInit() {
    final currentYear = DateTime.now().year;
    passingYears = List.generate(
      currentYear - 1990 + 1,
      (index) => (currentYear - index).toString(),
    );
    super.onInit();
  }

  void changeTab(int index) {
    tab.value = index;
  }
}
