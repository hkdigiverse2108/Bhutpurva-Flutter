import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/constants/app_size.dart';
import 'package:gurukul_bhutpurva/modules/manage/family/widgets/member_tile.dart';
import 'package:gurukul_bhutpurva/modules/profile/controllers/update_profile_controller.dart';
import 'package:gurukul_bhutpurva/modules/profile/widgets/update_form/address_details.dart';
import 'package:gurukul_bhutpurva/modules/profile/widgets/update_form/animated_tabs.dart';
import 'package:gurukul_bhutpurva/modules/profile/widgets/update_form/class_wise_study_details.dart';
import 'package:gurukul_bhutpurva/modules/profile/widgets/update_form/major_details.dart';
import 'package:gurukul_bhutpurva/modules/profile/widgets/update_form/primary_details.dart';
import 'package:gurukul_bhutpurva/modules/profile/widgets/update_form/secondary_details.dart';
import 'package:gurukul_bhutpurva/modules/profile/widgets/update_form/skill_and_hobbies.dart';

class UpdateProfile extends GetView<UpdateProfileController> {
  const UpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Profile')),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSize.cardRadiusLg),
            topRight: Radius.circular(AppSize.cardRadiusLg),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
              child: MemberTile(
                imageUrl: controller.storage.user.image ?? '',
                name: controller.fullName,
                phoneNumber: controller.storage.user.phoneNumber ?? '',
                isMainUser: true,
              ),
            ),
            const AnimatedProfileTabs(),
            const SizedBox(height: 12),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: [
                  UpdatePrimaryDetails(),
                  UpdateMajorDetails(),
                  UpdateClassWiseStudyDetails(),
                  UpdateAddressDetails(),
                  UpdateSecondaryDetails(),
                  UpdateSkillAndHobbies(),
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
                            ? controller.isUpdating.value
                                  ? null
                                  : () => controller.submit()
                            : () => controller.onTabTap(
                                controller.currentIndex.value + 1,
                              ),
                        child: controller.isUpdating.value
                            ? const CircularProgressIndicator()
                            : Text(
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
      ),
    );
  }
}
