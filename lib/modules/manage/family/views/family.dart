import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/manage/family/controllers/family_controller.dart';
import 'package:gurukul_bhutpurva/modules/manage/family/widgets/member_tile.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// USER CARD
            const MemberTile(
              imageUrl: '',
              name: 'KARTIK KAMALESH BHAI\nGONDALIYA',
              phoneNumber: '919106360330',
              isMainUser: true,
            ),

            const SizedBox(height: 4),

            /// HEADER ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Linked Family Member(s)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                ElevatedButton(
                  onPressed: controller.openAddMemberDialog,
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: const Text('Add Member'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            /// EMPTY STATE
            Expanded(
              child: Obx(
                () => controller.familyMembers.isEmpty
                    ? const Center(
                        child: Text(
                          'No family members found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.familyMembers.length,
                        itemBuilder: (_, index) {
                          final member = controller.familyMembers[index];
                          return MemberTile(
                            imageUrl: member.image,
                            name: member.name,
                            phoneNumber: member.phone,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
