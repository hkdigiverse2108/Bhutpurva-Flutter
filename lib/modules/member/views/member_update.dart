import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/constants/app_size.dart';
import 'package:gurukul_bhutpurva/modules/manage/family/widgets/member_tile.dart';
import 'package:gurukul_bhutpurva/modules/member/controllers/member_update_controller.dart';
import 'package:gurukul_bhutpurva/modules/member/widgets/update_form/address_details.dart';
import 'package:gurukul_bhutpurva/modules/member/widgets/update_form/animated_tabs.dart';
import 'package:gurukul_bhutpurva/modules/member/widgets/update_form/class_wise_study_details.dart';
import 'package:gurukul_bhutpurva/modules/member/widgets/update_form/major_details.dart';
import 'package:gurukul_bhutpurva/modules/member/widgets/update_form/primary_details.dart';
import 'package:gurukul_bhutpurva/modules/member/widgets/update_form/secondary_details.dart';
import 'package:gurukul_bhutpurva/modules/member/widgets/update_form/skill_and_hobbies.dart';

class MemberUpdate extends GetView<MemberUpdateController> {
  const MemberUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member'),
        centerTitle: false,
        actionsPadding: const EdgeInsets.only(right: 16),
        actions: [
          // Add verification status in app bar
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: controller.isVerified.value
                    ? Colors.green.shade100
                    : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    controller.isVerified.value
                        ? Icons.verified
                        : Icons.pending,
                    color: controller.isVerified.value
                        ? Colors.green
                        : Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    controller.isVerified.value ? 'Verified' : 'Not Verified',
                    style: TextStyle(
                      color: controller.isVerified.value
                          ? Colors.green.shade800
                          : Colors.orange.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Container(
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
                    // Edit Access Indicator
                    // Obx(
                    //   () => Container(
                    //     padding: const EdgeInsets.symmetric(vertical: 8),
                    //     color: controller.hasEditAccess.value
                    //         ? Colors.blue.shade50
                    //         : Colors.grey.shade200,
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Icon(
                    //           controller.hasEditAccess.value
                    //               ? Icons.edit
                    //               : Icons.lock_outline,
                    //           size: 16,
                    //           color: controller.hasEditAccess.value
                    //               ? Colors.blue
                    //               : Colors.grey,
                    //         ),
                    //         const SizedBox(width: 8),
                    //         Text(
                    //           controller.hasEditAccess.value
                    //               ? 'You have edit access'
                    //               : 'You do not have edit access',
                    //           style: TextStyle(
                    //             color: controller.hasEditAccess.value
                    //                 ? Colors.blue.shade800
                    //                 : Colors.grey.shade800,
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    if (!isKeyboardOpen)
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16, right: 16, left: 16),
                        child: Obx(
                          () => MemberTile(
                            imageUrl: controller.displayImage.value,
                            name:
                                '${controller.nameController.text} ${controller.fatherNameController.text}\n${controller.surnameController.text}'
                                    .trim(),
                            phoneNumber: controller.phoneController.text,
                            isMainUser: true,
                          ),
                        ),
                      ),
                    const AnimatedMemberTabs(),
                    const SizedBox(height: 12),
                    // Rest of the form
                    Expanded(
                      child: PageView(
                        controller: controller.pageController,
                        onPageChanged: controller.onPageChanged,
                        physics: controller.hasEditAccess.value
                            ? const PageScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        children: [
                          MemberPrimaryDetails(),
                          MemberMajorDetails(),
                          MemberAddressDetails(),
                          MemberSecondaryDetails(),
                          MemberClassWiseStudyDetails(),
                          MemberSkillAndHobbies(),
                        ],
                      ),
                    ),
                    // Navigation buttons
                    if (controller.hasEditAccess.value) ...[
                      const SizedBox(height: 12),
                      Padding(
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
                                child: const Text("Previous"),
                              ),
                            ),
                            const Spacer(),
                            Obx(
                              () => ElevatedButton(
                                onPressed: controller.currentIndex.value ==
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
                      const Gap(16),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
