import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';

class AboutAppController extends GetxController {
  final isLoading = false.obs;
  final apiService = ApiService.to;

  final htmlContent = "".obs;

  @override
  void onInit() {
    getAppInfo();
    super.onInit();
  }

  void getAppInfo() async {
    isLoading.value = true;
    try {
      final ResModel res = await apiService.get(ApiConstants.appInfo);
      if (res.status == 200) {
        if (res.data == null) {
          htmlContent.value = "";
        } else {
          htmlContent.value = res.data['content'];
        }
      }
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
