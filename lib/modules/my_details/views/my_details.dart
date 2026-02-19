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
    return Scaffold(
      appBar: AppBar(title: const Text('My Details')),
      backgroundColor: AppColors.primaryBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
              child: const MemberTile(
                imageUrl: '',
                name: 'KARTIK KAMALESH BHAI\nGONDALIYA',
                phoneNumber: '919106360330',
                isMainUser: true,
              ),
            ),
            const CustomDetailsTab(),
            Obx(
              () => controller.tab.value == 0
                  ? const MajorDetails()
                  : const ClassWiseStudyDetails(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AppButton(
          title: 'Save & Submit',
          backgroundColor: AppColors.primary,
          textColor: AppColors.white,
          borderColor: AppColors.primary,
          onTap: () {},
        ),
      ),
    );
  }
}
