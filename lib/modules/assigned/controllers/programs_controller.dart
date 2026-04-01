import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/data/models/batch/batch_model.dart';
import 'package:gurukul_bhutpurva/data/models/program/program_model.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';

class ProgramsController extends GetxController {
  static ProgramsController get instance => Get.find();

  final RxBool isSearch = false.obs;
  final RxBool isLoading = false.obs;
  late String batchId;

  final TextEditingController searchController = TextEditingController();

  final RxList<BatchStudentModel> members = <BatchStudentModel>[].obs;
  final RxList<BatchStudentModel> filteredMembers = <BatchStudentModel>[].obs;
  final apiService = ApiService.to;

  final currentIndex = 0.obs;

  final programs = <ProgramModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    batchId = Get.arguments;
    getPrograms();
    getBatchMembers();
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

  Future<void> getPrograms() async {
    try {
      isLoading.value = true;
      final response = await apiService.get(
        ApiConstants.getProgram(batchFilter: batchId),
      );

      if (response.status == 200) {
        final List<dynamic> programsList = response.data['programs'] ?? [];
        programs.assignAll(
          programsList.map((e) => ProgramModel.fromJson(e)).toList(),
        );
      }
    } catch (e) {
      debugPrint("Error fetching programs: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getBatchMembers() async {
    try {
      isLoading.value = true;
      final response = await apiService.get(ApiConstants.batchDetails(batchId));

      if (response.status == 200) {
        final batchData = BatchModel.fromJson(response.data);
        members.assignAll(batchData.students);
        filteredMembers.assignAll(members);
      }
    } catch (e) {
      debugPrint("Error fetching batch members: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProgram({
    required String name,
    required String description,
    required DateTime date,
  }) async {
    try {
      isLoading.value = true;

      final response = await apiService.post(
        ApiConstants.createProgram,
        body: {
          "name": name,
          "batchId": batchId,
          "description": description,
          "date": date.toIso8601String().split('T').first,
        },
      );

      if (response.status == 200 || response.status == 201) {
        AppSnackbar.success("Program created successfully");
        getPrograms();
      }
    } catch (e) {
      debugPrint("Error creating program: $e");
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, List<BatchStudentModel>> get groupedMembers {
    // 1️⃣ Make a copy and sort members
    final sortedMembers = [...members];
    sortedMembers.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    // 2️⃣ Group after sorting
    final Map<String, List<BatchStudentModel>> map = {};

    for (final member in sortedMembers) {
      final key = member.name[0].toUpperCase();
      map.putIfAbsent(key, () => []);
      map[key]!.add(member);
    }

    return map;
  }

  Map<String, List<BatchStudentModel>> get groupedFMembers {
    // 1️⃣ Make a copy and sort members
    final sortedMembers = [...filteredMembers];
    sortedMembers.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    // 2️⃣ Group after sorting
    final Map<String, List<BatchStudentModel>> map = {};

    for (final member in sortedMembers) {
      final key = member.name[0].toUpperCase();
      map.putIfAbsent(key, () => []);
      map[key]!.add(member);
    }

    return map;
  }
}
