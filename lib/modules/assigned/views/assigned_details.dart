import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/modules/assigned/controllers/assigned_details_controller.dart';
import 'package:gurukul_bhutpurva/modules/assigned/widgets/info_row.dart';
import 'package:gurukul_bhutpurva/modules/assigned/widgets/member_card.dart';
import 'package:gurukul_bhutpurva/shared/widgets/buttons/app_button.dart';

class AssignedDetails extends GetView<AssignedDetailsController> {
  const AssignedDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assigned Details"),
        actionsPadding: EdgeInsets.only(right: 16),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// CLASS NAME
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: Text(
                            controller.className.value,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Gap(10),
                        Obx(
                          () => Tooltip(
                            key: controller.verifiedHintKey,
                            message:
                                "Tap here to change verified / unverified status",
                            preferBelow: false,
                            verticalOffset: 10,
                            showDuration: const Duration(seconds: 3),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: const TextStyle(color: Colors.white),
                            child: GestureDetector(
                              onTap: () {
                                controller.isVerified.toggle();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: controller.isVerified.value
                                      ? AppColors.success
                                      : AppColors.error,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(6),
                                child: Icon(
                                  controller.isVerified.value
                                      ? Icons.verified
                                      : Icons.error_outline,
                                  color: AppColors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// INFO ROWS
                  infoRow(
                    icon: Icons.groups_rounded,
                    label: "Batch",
                    value: controller.batch,
                  ),

                  const SizedBox(height: 10),

                  infoRow(
                    icon: Icons.people_alt_rounded,
                    label: "Members",
                    value: controller.students,
                    suffix: " Members",
                  ),

                  /// EDIT BUTTON (ONLY FOR LEADER)
                  Obx(
                    () => controller.hasEditAccess.value
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: double.infinity,
                              child: AppButton(
                                title: "View Programs",
                                backgroundColor: AppColors.primary,
                                textColor: AppColors.white,
                                onTap: () {
                                  Get.toNamed(AppRoutes.programs);
                                },
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) {
                return _membersLoading();
              }

              if (controller.members.isEmpty) {
                return _emptyMembers();
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.members.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return MemberCard(member: controller.members[index]);
                },
              );
            }),
            const SizedBox(height: 50),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => controller.hasEditAccess.value
            ? FloatingActionButton.extended(
                onPressed: () {},
                label: const Text("View co-sah ordinator"),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _membersLoading() {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 90,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _emptyMembers() {
    return Column(
      children: const [
        SizedBox(height: 30),
        Icon(Icons.group_off_rounded, size: 60, color: Colors.grey),
        SizedBox(height: 12),
        Text(
          "No members assigned yet",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
