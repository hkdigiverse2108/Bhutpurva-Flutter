import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/data/models/attendance/attendance_model.dart';
import 'package:gurukul_bhutpurva/data/models/batch/batch_model.dart';
import 'package:gurukul_bhutpurva/data/models/program/program_model.dart';

class ProgramDetailsController extends GetxController {
  final RxBool isSearch = false.obs;

  final TextEditingController searchController = TextEditingController();

  final RxList<AttendanceModel> members = <AttendanceModel>[].obs;
  final RxBool isLoading = false.obs;
  final apiService = ApiService();
  late ProgramModel program;

  @override
  void onInit() {
    super.onInit();
    program = Get.arguments;
    getBatchMembers();
  }

  Future<void> getBatchMembers() async {
    if (program.batchId == null) return;

    try {
      isLoading.value = true;
      final response = await apiService.get(
        ApiConstants.batchDetails(program.batchId!.id),
      );

      if (response.status == 200) {
        final batchData = BatchModel.fromJson(response.data);
        members.assignAll(
          batchData.students.map((s) => AttendanceModel(
                id: s.id,
                name: s.fullName,
                mobile: s.phoneNumber,
                profileCompletion: s.profileCompletion,
                createdAt: DateTime.now(),
              )),
        );
        filteredMembers.assignAll(members);
      }
    } catch (e) {
      debugPrint("Error fetching batch members for attendance: $e");
    } finally {
      isLoading.value = false;
    }
  }

  final RxList<AttendanceModel> filteredMembers = <AttendanceModel>[].obs;

  void checkSearch() {
    if (searchController.text == "") {
      isSearch.value = false;
    } else {
      isSearch.value = true;
    }

    if (isSearch.value) {
      filteredMembers.assignAll(
        members.where(
          (member) => member.name.toLowerCase().contains(
            searchController.text.toLowerCase(),
          ),
        ),
      );
    } else {
      filteredMembers.assignAll(members);
    }
  }

  Map<String, List<AttendanceModel>> get groupedMembers {
    // 1️⃣ Make a copy and sort members
    final sortedMembers = [...members];
    sortedMembers.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    // 2️⃣ Group after sorting
    final Map<String, List<AttendanceModel>> map = {};

    for (final member in sortedMembers) {
      final key = member.name[0].toUpperCase();
      map.putIfAbsent(key, () => []);
      map[key]!.add(member);
    }

    return map;
  }

  Map<String, List<AttendanceModel>> get groupedFMembers {
    // 1️⃣ Make a copy and sort members
    final sortedMembers = [...filteredMembers];
    sortedMembers.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    // 2️⃣ Group after sorting
    final Map<String, List<AttendanceModel>> map = {};

    for (final member in sortedMembers) {
      final key = member.name[0].toUpperCase();
      map.putIfAbsent(key, () => []);
      map[key]!.add(member);
    }

    return map;
  }

  void changeAttendanceType(String id, AttendanceType type) {
    members.where((member) => member.id == id).first.attendanceType.value =
        type;
  }
}
