import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/modules/profile/controllers/update_profile_controller.dart';

class AnimatedProfileTabs extends GetView<UpdateProfileController> {
  const AnimatedProfileTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        // borderRadius: BorderRadius.circular(AppSize.cardRadiusLg),
      ),
      height: 52,
      child: ListView.builder(
        controller: controller.tabScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: controller.tabs.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          return Obx(() {
            final isActive = controller.currentIndex.value == index;

            return GestureDetector(
              onTap: () => controller.onTabTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                // margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isActive
                          ? AppColors.primary
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  controller.tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isActive ? AppColors.primary : Colors.black87,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
