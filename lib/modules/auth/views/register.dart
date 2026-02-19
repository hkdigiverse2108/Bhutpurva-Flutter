import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/constants/app_images.dart';
import 'package:gurukul_bhutpurva/core/constants/app_size.dart';
import 'package:gurukul_bhutpurva/modules/auth/controllers/register_controller.dart';
import 'package:gurukul_bhutpurva/modules/auth/widgets/animated_tabs.dart';
import 'package:gurukul_bhutpurva/modules/auth/widgets/register_sections/address_details.dart';
import 'package:gurukul_bhutpurva/modules/auth/widgets/register_sections/class_wise_study_details.dart';
import 'package:gurukul_bhutpurva/modules/auth/widgets/register_sections/major_details.dart';
import 'package:gurukul_bhutpurva/modules/auth/widgets/register_sections/primary_details.dart';
import 'package:gurukul_bhutpurva/modules/auth/widgets/register_sections/secondary_details.dart';
import 'package:gurukul_bhutpurva/modules/auth/widgets/register_sections/skill_and_hobbies.dart';

class Register extends GetView<RegisterController> {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSize.cardRadiusLg),
            topRight: Radius.circular(AppSize.cardRadiusLg),
          ),
        ),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.06,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.bg),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  height: AppSize.appBarHeight + 30,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [],
                  ),
                  padding: EdgeInsets.only(top: 30, left: 16, right: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: AppSize.iconMd,
                        backgroundImage: AssetImage(AppImages.logo),
                      ),
                      const Gap(AppSize.appBarPadding),
                      Text(
                        "Bhutpurva Register",
                        style: TextStyle(
                          fontSize: AppSize.fontSizeLg,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const AnimatedRegisterTabs(),
                const SizedBox(height: 12),
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    children: [
                      PrimaryDetails(),
                      MajorDetails(),
                      AddressDetails(),
                      SecondaryDetails(),
                      ClassWiseStudyDetails(),
                      SkillAndHobbies(),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Obx(
                          () => ElevatedButton(
                            onPressed: controller.currentIndex.value == 0
                                ? null
                                : () => controller.onTabTap(
                                    controller.currentIndex.value - 1,
                                  ),
                            child: Text("Previous"),
                          ),
                        ),
                        const Spacer(),
                        Obx(
                          () => ElevatedButton(
                            onPressed:
                                controller.currentIndex.value ==
                                    controller.tabs.length - 1
                                ? () => controller.submit()
                                : () => controller.onTabTap(
                                    controller.currentIndex.value + 1,
                                  ),
                            child: Text(
                              controller.currentIndex.value ==
                                      controller.tabs.length - 1
                                  ? 'Submit'
                                  : 'Save & Next',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
