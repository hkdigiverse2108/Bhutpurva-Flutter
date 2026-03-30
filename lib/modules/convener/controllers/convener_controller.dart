import 'dart:developer';

import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/data/models/group/group_model.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';

class ConvenerController extends GetxController {
  final groups = <GroupModel>[].obs;

  final isLoading = false.obs;

  final apiServices = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchGroups();
  }

  void fetchGroups() async {
    try {
      isLoading.value = true;

      final ResModel res = await apiServices.get(ApiConstants.groups());

      if (res.status == 200) {
        if (res.data == null) {
          groups.value = [];
        } else {
          groups.value = (res.data['groups'] as List)
              .map((e) => GroupModel.fromJson(e))
              .toList();
        }
      } else {
        AppSnackbar.error(res.message ?? '');
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
