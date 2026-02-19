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
          Obx(() => _heading(controller.groupDetails.value.name)),
          Expanded(child: _groupList()),
        ],
      ),
    );
  }

  Widget _heading(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
