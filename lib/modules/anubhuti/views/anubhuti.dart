import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/constants/app_images.dart';
import 'package:gurukul_bhutpurva/core/constants/app_size.dart';
import 'package:gurukul_bhutpurva/modules/anubhuti/controllers/anubhuti_controller.dart';
import 'package:gurukul_bhutpurva/shared/widgets/buttons/app_button.dart';
import 'package:gurukul_bhutpurva/shared/widgets/form_fields/common_text_form_field.dart';

class Anubhuti extends GetView<AnubhutiController> {
  const Anubhuti({super.key});

  void _showAnubhutiBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.lg,
              vertical: AppSize.xl,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSize.lg),
                  Text(
                    "Share Your Anubhuti",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: AppSize.xs),
                  Text(
                    "Describe your divine experience or testimonial here.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: AppSize.xl),
                  CommonTextFormField(
                    controller: controller.anubhutiController,
                    label: "Your Experience",
                    hintText: "Type your experience here...",
                    maxLines: 6,
                    isRequired: true,
                  ),
                  const SizedBox(height: AppSize.xl),
                  Obx(
                    () => AppButton(
                      title: "Submit Anubhuti",
                      icon: Icons.send_rounded,
                      backgroundColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      isLoading: controller.isLoading.value,
                      onTap: () {
                        if (!controller.isLoading.value) {
                          controller.sendAnubhuti();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: AppSize.md),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anubhuti')),
      body: Obx(() {
        final imageUrl = controller.anubhutiImage.value ?? '';
        final parsedUrl = imageUrl.startsWith('http')
            ? imageUrl
            : '${ApiConstants.baseUrl}/$imageUrl';

        return SizedBox.expand(
          child: Image.network(
            parsedUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Image.asset(AppImages.banner, fit: BoxFit.cover),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAnubhutiBottomSheet(context),
        label: const Text('Send Message'),
        icon: const Icon(Icons.send),
      ),
    );
  }
}
