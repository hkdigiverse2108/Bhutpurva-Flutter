import 'dart:developer';

import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/data/models/group/group_model.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';

class GroupsController extends GetxController {
  final classes = <ClassesModel>[].obs;
  var groupDetails = Rx<GroupModel?>(null);

  final isLoading = false.obs;
  final apiService = ApiService.to;

  @override
  void onInit() {
    super.onInit();
    groupDetails.value = Get.arguments;
    getGroupDetails();
  }

  void getGroupDetails() async {
    try {
      if (groupDetails.value == null) return;

      isLoading.value = true;

      final ResModel res = await apiService.get(
        ApiConstants.groupDetails(groupDetails.value!.id),
      );

      if (res.status == 200) {
        if (res.data != null) {
          final group = GroupModel.fromJson(res.data);

          classes.assignAll(
            group.batches
                .map(
                  (batch) => ClassesModel(
                    id: batch.id,
                    className: batch.name,
                    batch: batch.name,
                    members:
                        0, // Placeholder: Count not available in GroupModel yet
                    coSuhConvener:
                        [], // Placeholder: Not available in GroupModel yet
                  ),
                )
                .toList(),
          );
        }
      } else {
        AppSnackbar.error(res.message ?? 'Failed to fetch group details');
      }
    } catch (e) {
      log("Error fetching group details: $e");
      AppSnackbar.error("Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}

class ClassesModel {
  final String id;
  final String className;
  final String batch;
  final int members;
  final List<String> coSuhConvener;

  ClassesModel({
    required this.id,
    required this.className,
    required this.batch,
    required this.members,
    required this.coSuhConvener,
  });
}
