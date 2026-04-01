import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_size.dart';
import 'package:gurukul_bhutpurva/modules/manage/family/controllers/family_controller.dart';
import 'package:gurukul_bhutpurva/modules/manage/family/widgets/member_tile.dart';
import 'package:gurukul_bhutpurva/shared/widgets/buttons/app_button.dart';

class Family extends GetView<FamilyController> {
  const Family({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gurukul Bhutpurva'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.qr_code), onPressed: () {}),
        ],
      ),
      body: Obx(
        () => Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSize.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// USER CARD (Main User)
                  MemberTile(
                    imageUrl: controller.storageService.user.image ?? '',
                    name:
                        '${controller.storageService.user.name} ${controller.storageService.user.surname}'
                            .toUpperCase(),
                    phoneNumber:
                        controller.storageService.user.phoneNumber ?? '',
                    isMainUser: true,
                  ),

                  const SizedBox(height: AppSize.xs),

                  /// HEADER ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Linked Family Member(s)',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        onPressed: controller.openAddMemberDialog,
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('Add Member'),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSize.md),

                  /// MEMBERS LIST
                  Expanded(
                    child: controller.familyMembers.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.family_restroom_rounded,
                                  size: 64,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: AppSize.md),
                                Text(
                                  'No family members added yet',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 80),
                            itemCount: controller.familyMembers.length,
                            itemBuilder: (_, index) {
                              final member = controller.familyMembers[index];
                              return Stack(
                                children: [
                                  MemberTile(
                                    imageUrl: member.image,
                                    name: member.name,
                                    phoneNumber: member.phone,
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).primaryColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        member.relationship.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 12,
                                    right: 8,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      onPressed: () =>
                                          controller.removeMember(index),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

            /// SAVE BUTTON (Bottom)
            if (controller.familyMembers.isNotEmpty)
              Positioned(
                left: AppSize.md,
                right: AppSize.md,
                bottom: AppSize.md,
                child: AppButton(
                  title: "SAVE FAMILY",
                  icon: Icons.save_rounded,
                  backgroundColor: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  isLoading: controller.isLoading.value,
                  onTap: controller.saveFamily,
                ),
              ),

            /// LOADING OVERLAY
            if (controller.isLoading.value && controller.familyMembers.isEmpty)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
