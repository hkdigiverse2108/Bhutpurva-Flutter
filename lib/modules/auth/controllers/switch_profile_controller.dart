import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/data/models/user/stored_profile.dart';

class SwitchProfileController extends GetxController {
  final storage = Get.find<StorageService>();

  final profiles = <StoredProfile>[].obs;
  final activeIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfiles();
  }

  /// Loads stored profiles from local storage.
  void loadProfiles() {
    profiles.assignAll(storage.allProfiles);
    activeIndex.value = storage.activeProfileIndex;
  }

  /// Switches the active session to the profile at [index]
  /// and restarts the navigation.
  Future<void> selectProfile(int index) async {
    if (index < 0 || index >= profiles.length) return;

    await storage.switchToProfile(index);
    activeIndex.value = index;
    storage.isLoggedIn = true;
    Get.offAllNamed(AppRoutes.navigation);
  }

  /// Navigates to the login flow so the user can add another account.
  void addNewAccount() {
    Get.toNamed(AppRoutes.phoneLogin);
  }

  /// Removes a profile from the stored list.
  Future<void> removeProfile(int index) async {
    final remaining = await storage.removeProfile(index);
    loadProfiles();

    if (remaining == 0) {
      await storage.clearSession();
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
