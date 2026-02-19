import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/data/models/member/member_model.dart';
import 'package:gurukul_bhutpurva/data/models/program/program_model.dart';

class ProgramsController extends GetxController {
  static ProgramsController get instance => Get.find();

  final RxBool isSearch = false.obs;

  final TextEditingController searchController = TextEditingController();

  final RxList<MemberModel> members = <MemberModel>[
    MemberModel(
      name: 'Cnkur Vitthalbhai Gohil',
      id: '1',
      mobile: '1234567890',
      profileCompletion: 0.0,
      isVerified: false,
    ),
    MemberModel(
      name: 'Ankur Vitthalbhai Gohil',
      id: '1',
      mobile: '1234567890',
      profileCompletion: 0.0,
      isVerified: false,
    ),
    MemberModel(
      name: 'Amit Babubhai Jesadiya',
      id: '2',
      mobile: '1234567890',
      profileCompletion: 0.0,
      isVerified: false,
    ),
    MemberModel(
      name: 'Alpesh Lalubhai Thummar',
      id: '3',
      mobile: '1234567890',
      profileCompletion: 0.0,
      isVerified: false,
    ),
    MemberModel(
      name: 'Bhavesh Ghanshyambhai Dholariya',
      id: '4',
      mobile: '1234567890',
      profileCompletion: 0.0,
      isVerified: false,
    ),
    MemberModel(
      name: 'Brijesh Ashokbhai Vaghani',
      id: '5',
      mobile: '1234567890',
      profileCompletion: 0.0,
      isVerified: false,
    ),
    MemberModel(
      name: 'Bhargav Jayshukhbhai Kakadiya',
      id: '6',
      mobile: '1234567890',
      profileCompletion: 0.0,
      isVerified: false,
    ),
  ].obs;

  final RxList<MemberModel> filteredMembers = <MemberModel>[].obs;

  final currentIndex = 0.obs;

  final programs = <ProgramModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getPrograms();
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }

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

  void getPrograms() {
    programs.assignAll([
      ProgramModel(
        id: '1',
        name: 'Program A',
        details: 'This is a description of Program A',
      ),
      ProgramModel(
        id: '2',
        name: 'Program B',
        details: 'This is a description of Program B',
      ),
    ]);
  }

  void addProgram(String name) {
    final program = ProgramModel(id: DateTime.now().toString(), name: name);
    programs.add(program);
  }

  Map<String, List<MemberModel>> get groupedMembers {
    // 1️⃣ Make a copy and sort members
    final sortedMembers = [...members];
    sortedMembers.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    // 2️⃣ Group after sorting
    final Map<String, List<MemberModel>> map = {};

    for (final member in sortedMembers) {
      final key = member.name[0].toUpperCase();
      map.putIfAbsent(key, () => []);
      map[key]!.add(member);
    }

    return map;
  }

  Map<String, List<MemberModel>> get groupedFMembers {
    // 1️⃣ Make a copy and sort members
    final sortedMembers = [...filteredMembers];
    sortedMembers.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    // 2️⃣ Group after sorting
    final Map<String, List<MemberModel>> map = {};

    for (final member in sortedMembers) {
      final key = member.name[0].toUpperCase();
      map.putIfAbsent(key, () => []);
      map[key]!.add(member);
    }

    return map;
  }
}
