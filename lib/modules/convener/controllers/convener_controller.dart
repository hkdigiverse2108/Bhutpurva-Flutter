import 'dart:developer';

import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/data/models/group/group_model.dart';

class ConvenerController extends GetxController {
  final groups = <GroupModel>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGroups();
  }

  void fetchGroups() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 1));
      
      groups.assignAll([
        GroupModel(id: "1", name: "Group 1", description: "Description 1"),
        GroupModel(id: "2", name: "Group 2", description: "Description 2"),
        GroupModel(id: "3", name: "Group 3", description: "Description 3"),
      ]);
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
