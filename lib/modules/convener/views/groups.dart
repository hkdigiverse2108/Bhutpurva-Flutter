import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/convener/controllers/groups_controller.dart';
import 'package:gurukul_bhutpurva/modules/convener/widgets/group_tile.dart';

class Groups extends GetView<GroupsController> {
  const Groups({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Class List')),
      body: Column(
        children: [
          Obx(() => _heading(controller.groupDetails.value?.name ?? "")),
          Expanded(child: _groupList()),
        ],
      ),
    );
  }

  Widget _heading(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Get.theme.primaryColor,
            Get.theme.primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Get.theme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title.capitalizeFirst ?? title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Classes Assigned",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _groupList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.classes.isEmpty) {
        return const Center(child: Text("No classes assigned"));
      }

      return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        shrinkWrap: true,
        itemCount: controller.classes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          final cla = controller.classes[index];
          return ClassTile(item: cla);
        },
      );
    });
  }
}
