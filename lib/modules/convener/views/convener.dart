import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/data/models/group/group_model.dart';
import 'package:gurukul_bhutpurva/modules/convener/controllers/convener_controller.dart';

class Convener extends GetView<ConvenerController> {
  const Convener({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Convener')),
      body: Obx(() {
        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemBuilder: (context, index) =>
              _GroupCard(item: controller.groups[index]),
          separatorBuilder: (context, index) => const Gap(12),
          itemCount: controller.groups.length,
        );
      }),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final GroupModel item;

  const _GroupCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.groups, arguments: item);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LEFT ICON
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.school_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),

            const SizedBox(width: 12),

            /// CENTER DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Description: ${item.description}",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
