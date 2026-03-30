import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:gurukul_bhutpurva/shared/global/global_ver.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';

class LifeLightController extends GetxController {
  final apiSirvices = ApiService();
  final StorageService storage = Get.find();

  final Rx<String?> lifeLightImage =
      globalSettings?.lifeLightImage.obs ?? "".obs;

  void openFillForm(BuildContext context) {
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
                'Submit Life Light',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              /// TEXT FIELD
              TextField(
                controller: feedbackController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your Life Light here...',
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
                                    'Please enter your Life Light',
                                  );
                                  return;
                                }

                                isSubmitting.value = true;

                                submitLifeLight(feedback);

                                Get.back();
                                isSubmitting.value = false;
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

  void submitLifeLight(String lifeLight) async {
    try {
      final ResModel res = await apiSirvices.post(
        ApiConstants.lifeLight,
        body: {'userId': storage.user.id, 'lifeLight': lifeLight},
      );
      if (res.status == 200) {
        AppSnackbar.success('Your Life Light has been submitted.');
      } else {
        AppSnackbar.error(res.message ?? '');
      }
    } catch (e) {
      AppSnackbar.error('Something went wrong');
    }
  }
}
