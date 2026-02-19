import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/data/models/attendance/attendance_model.dart';

class ProgramDetailsController extends GetxController {
  final RxBool isSearch = false.obs;

  final TextEditingController searchController = TextEditingController();

  final RxList<AttendanceModel> members = <AttendanceModel>[
    AttendanceModel(
      name: 'Cnkur Vitthalbhai Gohil',
      id: '0',
      mobile: '1234567890',
      profileCompletion: 0.0,
      createdAt: DateTime.now(),
    ),
    // AttendanceModel(
    //   name: 'Ankur Vitthalbhai Gohil',
    //   id: '1',
    //   mobile: '1234567890',
    //   profileCompletion: 0.0,
    // ),
    // AttendanceModel(
    //   name: 'Amit Babubhai Jesadiya',
    //   id: '2',
    //   mobile: '1234567890',
    //   profileCompletion: 0.0,
    // ),
    // AttendanceModel(
    //   name: 'Alpesh Lalubhai Thummar',
    //   id: '3',
    //   mobile: '1234567890',
    //   profileCompletion: 0.0,
    // ),
    // AttendanceModel(
    //   name: 'Bhavesh Ghanshyambhai Dholariya',
    //   id: '4',
    //   mobile: '1234567890',
    //   profileCompletion: 0.0,
    // ),
    // AttendanceModel(
    //   name: 'Brijesh Ashokbhai Vaghani',
    //   id: '5',
    //   mobile: '1234567890',
    //   profileCompletion: 0.0,
    // ),
    // AttendanceModel(
    //   name: 'Bhargav Jayshukhbhai Kakadiya',
    //   id: '6',
    //   mobile: '1234567890',
    //   profileCompletion: 0.0,
    // ),
  ].obs;

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
