import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/data/models/life_light/life_light_model.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';

class StatusController extends GetxController {
  final apiService = ApiService.to;
  final StorageService storage = Get.find();

  final isLoading = false.obs;
  final List<LifeLightModel> lifeLight = <LifeLightModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getLifeLight();
  }

  void getLifeLight() async {
    try {
      isLoading.value = true;
      final ResModel res = await apiService.get(
        ApiConstants.getLifeLightById(storage.user.id ?? ""),
      );
      if (res.status == 200) {
        res.data.forEach((element) {
          lifeLight.add(LifeLightModel.fromJson(element));
        });
      }
    } catch (e) {
      AppSnackbar.error('Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }
}
