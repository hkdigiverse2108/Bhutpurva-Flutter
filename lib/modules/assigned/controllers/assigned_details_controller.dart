import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/data/models/member/member_model.dart';
import 'package:gurukul_bhutpurva/modules/assigned/controllers/assigned_controller.dart';

class AssignedDetailsController extends GetxController {
  final isLoading = true.obs;
  final hasEditAccess = false.obs;
  final isVerified = false.obs;

  final className = "Class Name".obs;
  final batch = "Batch A".obs;
  final students = 0.obs;
  final status = "Active".obs;

  final members = <MemberModel>[].obs;
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

    final AssignedClass args = Get.arguments;

    className.value = args.className;
    batch.value = args.batch;
    students.value = args.students;

    if (storageService.isLeader || storageService.isConvener) {
      hasEditAccess.value = true;
    }

    /// DUMMY MEMBERS DATA
    members.assignAll(_dummyMembers());

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
}
