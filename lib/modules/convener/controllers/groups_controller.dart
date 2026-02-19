import 'dart:developer';

import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/data/models/group/group_model.dart';

class GroupsController extends GetxController {
  final classes = <ClassesModel>[].obs;
  var groupDetails = GroupModel(id: '', description: '', name: '').obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    groupDetails.value = Get.arguments;
    groupDetails.update;
    getGroupDetails();
  }

  void getGroupDetails() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 1));

      classes.assignAll([
        ClassesModel(
          className: "Class 1",
          batch: "Batch 1",
          members: 20,
          coSuhConvener: ["Convener 1", "Convener 2"],
        ),
        ClassesModel(
          className: "Class 2",
          batch: "Batch 2",
          members: 20,
          coSuhConvener: ["Convener 1", "Convener 2"],
        ),
        ClassesModel(
          className: "Class 3",
          batch: "Batch 3",
          members: 20,
          coSuhConvener: [],
        ),
      ]);
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

class ClassesModel {
  final String className;
  final String batch;
  final int members;
  final List<String> coSuhConvener;

  ClassesModel({
    required this.className,
    required this.batch,
    required this.members,
    required this.coSuhConvener,
  });
}
