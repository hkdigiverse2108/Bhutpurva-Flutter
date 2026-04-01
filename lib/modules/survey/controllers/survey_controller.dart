import 'dart:developer';

import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:gurukul_bhutpurva/data/models/survey/survey_model.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';

class SurveyController extends GetxController {
  final RxBool isLoading = false.obs;
  final apiService = ApiService.to;

  final RxList<SurveyModel> surveys = <SurveyModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSurveys();
  }

  Future<void> fetchSurveys() async {
    try {
      isLoading.value = true;
      final ResModel res = await apiService.get(ApiConstants.surveys);
      log("Survey API Response Status: ${res.status}");
      log("Survey API Response Data Type: ${res.data.runtimeType}");

      if (res.status == 200) {
        List<dynamic> rawData = [];
        if (res.data is List) {
          rawData = res.data;
        } else if (res.data is Map && res.data.containsKey('surveys')) {
          rawData = res.data['surveys'];
        } else if (res.data is Map) {
          // If it's a map but no 'surveys' key, maybe it's the data itself?
          // Or maybe we treat the values as the list?
          rawData = res.data.values.toList();
        }

        final List<SurveyModel> data = rawData
            .map((e) => SurveyModel.fromJson(e))
            .toList();
        surveys.assignAll(data);
      } else {
        AppSnackbar.error(res.message ?? '');
      }
    } catch (e) {
      log("Fetch Surveys Error: $e");
      AppSnackbar.error('Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshSurveys() async {
    await fetchSurveys();
  }
}
