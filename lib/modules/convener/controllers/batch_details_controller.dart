import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/data/models/batch/batch_model.dart';
import 'package:gurukul_bhutpurva/data/models/monitor/monitor_model.dart';
import 'package:gurukul_bhutpurva/modules/assigned/controllers/assigned_controller.dart';
import 'package:gurukul_bhutpurva/modules/convener/controllers/groups_controller.dart';

class BatchDetailsController extends GetxController {
  final isLoading = true.obs;
  final hasEditAccess = false.obs;
  final isVerified = false.obs;
  final showMonitors = false.obs;

  final className = "Class Name".obs;
  final batch = "Batch".obs;
  final studentsCount = 0.obs;

  final members = <BatchStudentModel>[].obs;
  final monitors = <MonitorModel>[].obs;
  final GlobalKey verifiedHintKey = GlobalKey();

  final storageService = Get.find<StorageService>();
  final apiService = ApiService();
  final Rxn<BatchModel> batchData = Rxn<BatchModel>();

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

    // Simulate API delay (replace with real API call later)
    await Future.delayed(const Duration(seconds: 1));

    final dynamic args = Get.arguments;
    String? batchId;

    if (args is String) {
      batchId = args;
    } else if (args is ClassesModel) {
      batchId = args.id; // Assuming ClassesModel has an id
      className.value = args.className;
      batch.value = args.batch;
      studentsCount.value = args.members;
    } else if (args is AssignedClass) {
      batchId = args.id; // Assuming AssignedClass has an id
      className.value = args.className;
      batch.value = args.batch;
      studentsCount.value = args.students;
    }

    if (batchId != null) {
      try {
        final response = await apiService.get(
          ApiConstants.batchDetails(batchId),
        );
        if (response.status == 200) {
          batchData.value = BatchModel.fromJson(
            response.data as Map<String, dynamic>,
          );

          className.value = batchData.value?.groupId.name ?? className.value;
          batch.value = batchData.value?.name ?? batch.value;
          studentsCount.value =
              batchData.value?.studentCount ?? studentsCount.value;
          members.assignAll(batchData.value?.students ?? []);
          isVerified.value = batchData.value?.isActive ?? false;
          showMonitors.value = true;
        }
      } catch (e) {
        log("Error fetching batch details: $e");
      }
    }

    if (storageService.isLeader || storageService.isConvener) {
      hasEditAccess.value = true;
    }

    if (showMonitors.value && monitors.isEmpty) {
      monitors.assignAll(_dummyMonitors());
    }

    isLoading.value = false;
  }

  List<MonitorModel> _dummyMonitors() {
    return [
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
              const Text(
                'Delete Monitor?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to delete this monitor?\nThis action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
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
