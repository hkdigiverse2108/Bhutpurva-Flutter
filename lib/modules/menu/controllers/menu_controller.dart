import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:gurukul_bhutpurva/shared/global/global_ver.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';
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

  void logout() async {
    // Show loading dialog
    Get.dialog(
      const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Logging out...', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      log(storage.token!);
      final ResModel response = await apiSirvices.post(
        ApiConstants.logout,
        body: {},
        headers: {'authorization': storage.token!},
      );

      if (response.status == 200) {
        await storage.clearSession();
        Get.back(); // close dialog
        Get.offAllNamed(AppRoutes.login);
        return;
      }
    } catch (e) {
      log(e.toString());
    }

    // Close dialog on failure
    if (Get.isDialogOpen ?? false) Get.back();
    AppSnackbar.error('Logout failed');
  }
}
