import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/modules/manage/family/widgets/member_tile.dart';
import 'package:gurukul_bhutpurva/modules/my_details/controllers/my_details_controller.dart';
import 'package:gurukul_bhutpurva/modules/my_details/widgets/custom_details_tab.dart';
import 'package:gurukul_bhutpurva/shared/widgets/buttons/app_button.dart';

import '../widgets/class_wise_study_details.dart';
import '../widgets/major_details.dart';

class MyDetails extends GetView<MyDetailsController> {
  const MyDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final user = controller.storage.user;

    return Scaffold(
      appBar: AppBar(title: const Text('My Details')),
      backgroundColor: AppColors.primaryBackground,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
            child: MemberTile(
              imageUrl: user.image ?? '',
              name:
                  '${user.name ?? ''} ${user.fatherName ?? ''}\n${user.surname ?? ''}',
              phoneNumber: user.phoneNumber ?? '',
              isMainUser: true,
            ),
          ),
          const CustomDetailsTab(),
          Expanded(
            child: Obx(
              () => IndexedStack(
                index: controller.tab.value,
                children: const [MajorDetails(), ClassWiseStudyDetails()],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => AppButton(
            title: 'Save & Submit',
            isLoading: controller.isLoading.value,
            backgroundColor: AppColors.primary,
            textColor: AppColors.white,
            borderColor: AppColors.primary,
            onTap: controller.saveDetails,
          ),
        ),
      ),
    );
  }
}
