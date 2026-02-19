import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/manage/emails/controllers/emails_controller.dart';
import 'package:gurukul_bhutpurva/modules/manage/emails/widgets/email_tile.dart';
import 'package:gurukul_bhutpurva/modules/manage/emails/widgets/empty_state.dart';

class Emails extends GetView<EmailsController> {
  const Emails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      appBar: AppBar(title: const Text('Manage Emails'), centerTitle: true),
      body: Obx(() {
        if (controller.emails.isEmpty) {
          return EmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.emails.length,
          itemBuilder: (context, index) {
            final email = controller.emails[index];
            return EmailTile(
              email: email,
              onDelete: () => _confirmDelete(email),
            );
          },
        );
      }),
    );
  }

  /// DELETE CONFIRMATION
  void _confirmDelete(String email) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove Email'),
        content: Text('Are you sure you want to remove:\n$email'),
        actions: [
          TextButton(
            onPressed: Get.back,
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.removeEmail(email);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
