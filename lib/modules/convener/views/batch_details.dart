import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/data/models/member/member_model.dart';
import 'package:gurukul_bhutpurva/modules/assigned/widgets/member_card.dart';
import 'package:gurukul_bhutpurva/modules/convener/controllers/batch_details_controller.dart';
import 'package:gurukul_bhutpurva/modules/convener/widgets/monitor_tile.dart';

class BatchDetails extends GetView<BatchDetailsController> {
  const BatchDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.showMonitors.value) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Assigned Details"),
            actionsPadding: const EdgeInsets.only(right: 16),
          ),
          body: _allStudents(context),
          floatingActionButton: controller.hasEditAccess.value
              ? FloatingActionButton.extended(
                  onPressed: () {},
                  label: const Text("View co - ordinator"),
                )
              : const SizedBox.shrink(),
        );
      }

      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Assigned Details"),
            actionsPadding: const EdgeInsets.only(right: 16),
          ),
          body: Column(
            children: [
              _tabSection(),
              Expanded(
                child: TabBarView(
                  children: [
                    _allStudents(context),
                    _assignedContent(),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: controller.hasEditAccess.value
              ? FloatingActionButton.extended(
                  onPressed: () {},
                  label: const Text("View co - ordinator"),
                )
              : const SizedBox.shrink(),
        ),
      );
    });
  }

  Widget _allStudents(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// CLASS NAME & VERIFIED BADGE
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => Text(
                          controller.className.value,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => GestureDetector(
                        onTap: () {
                          controller.isVerified.toggle();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: controller.isVerified.value
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: controller.isVerified.value
                                  ? Colors.green.withValues(alpha: 0.2)
                                  : Colors.red.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                controller.isVerified.value
                                    ? Icons.verified_rounded
                                    : Icons.error_outline_rounded,
                                color: controller.isVerified.value
                                    ? Colors.green
                                    : Colors.red,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                controller.isVerified.value
                                    ? "Verified"
                                    : "Unverified",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: controller.isVerified.value
                                      ? Colors.green[700]
                                      : Colors.red[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// INFO SECTION
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildModernInfoRow(
                        context,
                        Icons.layers_rounded,
                        "Batch",
                        controller.batch.value,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1),
                      ),
                      _buildModernInfoRow(
                        context,
                        Icons.people_alt_rounded,
                        "Members",
                        "${controller.studentsCount.value} Members",
                      ),
                    ],
                  ),
                ),

                /// VIEW PROGRAMS BUTTON
                Obx(
                  () => controller.hasEditAccess.value
                      ? Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Get.toNamed(AppRoutes.programs);
                              },
                              icon: const Icon(
                                Icons.auto_awesome_motion_rounded,
                                size: 20,
                              ),
                              label: const Text("View All Programs"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          /// STUDENTS LIST HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "All Students",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                Obx(
                  () => Text(
                    "${controller.members.length} Total",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
                final student = controller.members[index];
                // Mapping BatchStudentModel to MemberModel to avoid UI changes in MemberCard
                final memberMapping = MemberModel(
                  id: student.id,
                  name: student.fullName,
                  mobile: student.phoneNumber,
                  profileCompletion: student.profileCompletion,
                  isVerified: student.isVerified,
                );
                return MemberCard(member: memberMapping);
              },
            );
          }),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildModernInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _assignedContent() {
    return Obx(() {
      if (controller.monitors.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Monitors",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Gap(12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.monitors.length,
              separatorBuilder: (_, __) => const Gap(12),
              itemBuilder: (context, index) {
                return MonitorTile(
                  monitor: controller.monitors[index],
                  onDelete: () {
                    controller.showDeleteMonitorDialog(index);
                  },
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _tabSection() {
    return const TabBar(
      indicatorColor: AppColors.primary,
      labelColor: AppColors.primary,
      unselectedLabelColor: Colors.black,
      dividerColor: Colors.transparent,
      tabs: [
        Tab(text: 'All Students'),
        Tab(text: 'Assigned'),
      ],
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
