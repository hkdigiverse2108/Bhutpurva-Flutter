import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:gurukul_bhutpurva/shared/global/global_ver.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MenusController extends GetxController {
  final storage = Get.find<StorageService>();
  final apiSirvices = ApiService();

  void navigateToTechnicalSupport() {
    Get.toNamed(AppRoutes.technicalSupport);
  }

  void navigateToAboutApp() {
    Get.toNamed(AppRoutes.aboutApp);
  }

  void openFeedback(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();
    final RxBool isSubmitting = false.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE
              const Text(
                'Send Feedback',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              /// SUBTITLE
              const Text(
                'We value your feedback. Please share your thoughts.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 16),

              /// TEXT FIELD
              TextField(
                controller: feedbackController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your feedback here...',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: isSubmitting.value
                            ? null
                            : () async {
                                final feedback = feedbackController.text.trim();

                                if (feedback.isEmpty) {
                                  AppSnackbar.warning(
                                    'Please enter your feedback',
                                  );
                                  return;
                                }

                                isSubmitting.value = true;

                                submitFeedback(feedback);

                                isSubmitting.value = false;
                                Get.back();
                              },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isSubmitting.value
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Submit'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitFeedback(String feedback) async {
    try {
      log("ID: ${storage.user.name}");
      final ResModel res = await apiSirvices.post(
        ApiConstants.feedback,
        body: {'userId': storage.user.id, 'feedback': feedback},
      );

      if (res.status == 200) {
        AppSnackbar.success('Your feedback has been submitted.');
      } else {
        AppSnackbar.error(res.message ?? '');
      }
    } catch (e) {
      log(e.toString());
      AppSnackbar.error('Something went wrong');
    }
  }

  void shareApp(BuildContext context) async {
    const String appName = 'Gurukul Bhutpurva App';
    final String message =
        '''
    🙏 Check out the $appName!
    
    Stay connected with Gurukul activities, attendance, surveys, and community events.
    
    📲 Download here:
    Android: ${globalSettings?.playStoreUrl}
    iOS: ${globalSettings?.appStoreUrl}
    ''';

    // Calculate share sheet origin (important especially on iPads)
    final box = context.findRenderObject() as RenderBox?;
    final origin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : const Rect.fromLTWH(0, 0, 1, 1);

    await SharePlus.instance.share(
      ShareParams(text: message, title: appName, sharePositionOrigin: origin),
    );
  }

  Future<void> openAllSgrsApps() async {
    /// Play Store developer page URL
    final String playStoreDeveloperUrl =
        'https://play.google.com/store/apps/developer?id=${globalSettings?.playStoreId}';

    final uri = Uri.parse(playStoreDeveloperUrl);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Error', 'Unable to open Play Store');
    }
  }

  void navigateToPolicies() {
    Get.toNamed(AppRoutes.policies);
  }

  void logout() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔴 ICON HEADER
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  PhosphorIconsFill.signOut,
                  color: AppColors.error,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),

              // 📝 TEXT CONTENT
              const Text(
                'Logout?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Are you sure you want to log out of your account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // ⚡ ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // close confirmation dialog
                        _performLogout(); // start logout process
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performLogout() async {
    // Show loading dialog
    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 20),
              const Text(
                'Logging out...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      if (storage.token != null) {
        log(storage.token!);
        await apiSirvices.post(
          ApiConstants.logout,
          body: {},
          headers: {'authorization': storage.token!},
        );
      }

      // Remove current profile from the stored list
      final currentIndex = storage.activeProfileIndex;
      final remaining = await storage.removeProfile(currentIndex);
      await storage.clearSession();

      if (Get.isDialogOpen ?? false) Get.back(); // close loading dialog

      if (remaining > 0) {
        // Switch to the first remaining profile and show picker
        await storage.switchToProfile(0);
        Get.offAllNamed(AppRoutes.switchProfile);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      log(e.toString());
      if (Get.isDialogOpen ?? false) Get.back();
      AppSnackbar.error('Logout failed');
    }
  }
}
