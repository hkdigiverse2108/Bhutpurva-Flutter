import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/data/models/member/member_model.dart';
import 'package:gurukul_bhutpurva/data/models/monitor/monitor_model.dart';
import 'package:gurukul_bhutpurva/modules/convener/controllers/groups_controller.dart';

class GroupDetailsController extends GetxController {
  final isLoading = true.obs;
  final hasEditAccess = false.obs;
  final isVerified = false.obs;

  final className = "Class Name".obs;
  final batch = "Batch A".obs;
  final students = 10.obs;
  final status = "Active".obs;

  final members = <MemberModel>[].obs;
  final monitors = <MonitorModel>[].obs;
  final GlobalKey verifiedHintKey = GlobalKey();

  final storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dynamic tooltip = verifiedHintKey.currentState;

      tooltip?.ensureTooltipVisible();
    });

    initData();
  }

  Future<void> initData() async {
    isLoading.value = true;

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    final ClassesModel args = Get.arguments;

    className.value = args.className;
    batch.value = args.batch;

    if (storageService.isLeader || storageService.isConvener) {
      hasEditAccess.value = true;
    }

    /// DUMMY MEMBERS DATA
    members.assignAll(_dummyMembers());
    monitors.assignAll(_dummyMonitor());

    isLoading.value = false;
  }

  List<MemberModel> _dummyMembers() {
    return [
      MemberModel(
        name: "Rahul Patel",
        mobile: "9876543210",
        profileCompletion: 80,
        isVerified: true,
        id: "1",
      ),
      MemberModel(
        name: "Amit Shah",
        mobile: "9123456789",
        profileCompletion: 65,
        isVerified: true,
        id: "2",
      ),
      MemberModel(
        name: "Neha Joshi",
        mobile: "9988776655",
        profileCompletion: 95,
        isVerified: true,
        id: "3",
      ),
    ];
  }

  List<MonitorModel> _dummyMonitor() {
    return [
      MonitorModel(
        name: 'Rahul Patel',
        mobile: '9312345678',
        assignedMembers: ['Rahul Patel', 'Amit Shah', 'Neha Joshi'],
      ),
      MonitorModel(
        name: 'Rahul Patel',
        mobile: '9312345678',
        assignedMembers: ['Rahul Patel', 'Amit Shah', 'Neha Joshi'],
      ),
    ];
  }

  Future<void> showDeleteMonitorDialog(int index) async {
    final bool? result = await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ICON
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 32,
                ),
              ),

              const SizedBox(height: 16),

              /// TITLE
              const Text(
                'Delete Monitor?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              /// MESSAGE
              Text(
                'Are you sure you want to delete this monitor?\nThis action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),

              const SizedBox(height: 24),

              /// ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    if (result == true) {
      deleteMonitor(index);
    }
  }

  void deleteMonitor(int index) {
    monitors.removeAt(index);
  }
}
