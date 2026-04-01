import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/data/models/attendance/attendance_model.dart';
import 'package:gurukul_bhutpurva/data/models/program/program_model.dart';

class AttendanceMember {
  final StudentId studentId;
  final Rx<AttendanceType> attendanceType;

  AttendanceMember({
    required this.studentId,
    AttendanceType initialType = AttendanceType.notSelected,
  }) : attendanceType = initialType.obs;

  String get id => studentId.id;
  String get name => studentId.name;
}

class ProgramDetailsController extends GetxController {
  final RxBool isSearch = false.obs;

  final TextEditingController searchController = TextEditingController();

  final RxList<AttendanceMember> members = <AttendanceMember>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasChanges = false.obs;
  final apiService = ApiService.to;
  late ProgramModel program;
  late String attendanceId;

  @override
  void onInit() {
    super.onInit();
    program = Get.arguments;
    getAttendance();
  }

  Future<void> getAttendance() async {
    try {
      isLoading.value = true;
      final response = await apiService.get(
        ApiConstants.programAttendance(program.id),
      );

      if (response.status == 200) {
        final attendanceData = AttendanceModel.fromJson(response.data);
        attendanceId = attendanceData.id;
        members.assignAll(
          attendanceData.students.map(
            (s) => AttendanceMember(
              studentId: s.studentId,
              initialType: s.isPresent == null
                  ? AttendanceType.notSelected
                  : s.isPresent!
                  ? AttendanceType.present
                  : AttendanceType.absent,
            ),
          ),
        );
        filteredMembers.assignAll(members);
      }
    } catch (e) {
      debugPrint("Error fetching batch members for attendance: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAttendance() async {
    try {
      isLoading.value = true;
      final response = await apiService.put(
        ApiConstants.updateAttendance,
        body: {
          'attendanceId': attendanceId,
          'students': members
              .map(
                (m) => {
                  'studentId': m.id,
                  'isPresent': m.attendanceType.value == AttendanceType.present
                      ? true
                      : m.attendanceType.value == AttendanceType.absent
                      ? false
                      : null,
                },
              )
              .toList(),
        },
      );

      if (response.status == 200) {
        hasChanges.value = false;
        Get.back();
      }
    } catch (e) {
      debugPrint("Error updating attendance: $e");
    } finally {
      isLoading.value = false;
    }
  }

  final RxList<AttendanceMember> filteredMembers = <AttendanceMember>[].obs;

  void checkSearch() {
    final query = searchController.text.toLowerCase();
    isSearch.value = query.isNotEmpty;

    filteredMembers.assignAll(
      query.isEmpty
          ? members
          : members.where((m) => m.name.toLowerCase().contains(query)),
    );
  }

  Map<String, List<AttendanceMember>> groupedList(
    List<AttendanceMember> source,
  ) {
    final sorted = [...source]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    final Map<String, List<AttendanceMember>> map = {};
    for (final member in sorted) {
      final key = member.name[0].toUpperCase();
      map.putIfAbsent(key, () => []);
      map[key]!.add(member);
    }
    return map;
  }

  void changeAttendanceType(String id, AttendanceType type) {
    members.where((member) => member.id == id).first.attendanceType.value =
        type;
    hasChanges.value = true;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
