import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/constants/app_images.dart';
import 'package:gurukul_bhutpurva/modules/life_light/controllers/life_light_controller.dart';
import 'package:gurukul_bhutpurva/shared/widgets/buttons/app_button.dart';

class LifeLight extends GetView<LifeLightController> {
  const LifeLight({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Life Light')),
      // extendBodyBehindAppBar: true,
      body: Obx(() {
        final imageUrl = controller.lifeLightImage.value ?? '';
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Gap(16),
          Expanded(
            child: AppButton(
              title: 'Status',
              backgroundColor: AppColors.grey,
              textColor: AppColors.white,
              onTap: () {
                Get.toNamed(AppRoutes.status);
              },
            ),
          ),
          const Gap(16),
          Expanded(
            child: AppButton(
              title: 'Fill Form',
              backgroundColor: AppColors.primary,
              textColor: AppColors.white,
              onTap: () {
                controller.openFillForm(context);
              },
            ),
          ),
          const Gap(16),
        ],
      ),
    );
  }
}
