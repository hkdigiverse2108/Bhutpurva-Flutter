import 'dart:developer';

import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';

class PoliciesController extends GetxController {
  final htmlPolicyContent = "".obs;
  final htmlTermsContent = "".obs;
  final isLoading = false.obs;
  final isTermsLoading = false.obs;

  final apiSirvices = ApiService();

  @override
  void onInit() {
    getAppPolicy();
    getAppTerms();
    super.onInit();
  }

  void getAppPolicy() async {
    isLoading.value = true;
    try {
      final ResModel res = await apiSirvices.get(ApiConstants.appPolicy);

      if (res.status == 200) {
        if (res.data == null) {
          htmlPolicyContent.value = "";
        } else {
          htmlPolicyContent.value = res.data['content'];
        }
      } else {
        AppSnackbar.error(res.message ?? '');
      }
    } catch (e) {
      log(e.toString());
      AppSnackbar.error('Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  void getAppTerms() async {
    isTermsLoading.value = true;
    try {
      final ResModel res = await apiSirvices.get(ApiConstants.appTerms);

      if (res.status == 200) {
        if (res.data == null) {
          htmlTermsContent.value = "";
        } else {
          htmlTermsContent.value = res.data['content'];
        }
      } else {
        AppSnackbar.error(res.message ?? '');
      }
    } catch (e) {
      log(e.toString());
      AppSnackbar.error('Something went wrong');
    } finally {
      isTermsLoading.value = false;
    }
  }
}
