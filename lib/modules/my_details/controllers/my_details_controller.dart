import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/data/models/branch/branch_model.dart';
import 'package:gurukul_bhutpurva/data/models/class/class_model.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:gurukul_bhutpurva/data/models/user/user_model.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';

class MyDetailsController extends GetxController {
  final StorageService storage = Get.find<StorageService>();
  final apiService = ApiService.to;

  final majorDetailsFormKey = GlobalKey<FormState>();
  final classDetailsFormKey = GlobalKey<FormState>();

  final tab = 0.obs;
  final isLoading = false.obs;

  // Major Details
  final hrNoController = TextEditingController();
  final currentCity = 'select'.obs;
  final area = 'select'.obs;
  final tenTh = ClassModel().obs;
  final twelveTh = ClassModel().obs;
  final studyField = 'Not Selected'.obs;

  // Class Details
  final class1 = ClassModel().obs;
  final class2 = ClassModel().obs;
  final class3 = ClassModel().obs;
  final class4 = ClassModel().obs;
  final class5 = ClassModel().obs;
  final class6 = ClassModel().obs;
  final class7 = ClassModel().obs;
  final class8 = ClassModel().obs;
  final class9 = ClassModel().obs;
  final class10 = ClassModel().obs;
  final class11 = ClassModel().obs;
  final class12 = ClassModel().obs;

  final branch = <BranchModel>[].obs;

  final currentCityList = <String>['select', 'surat', 'other'].obs;

  late final List<String> passingYears;
  late final List<String> hostels = [
    'not Selected',
    'hostel',
    'non hostel',
  ].obs;

  @override
  void onInit() {
    final currentYear = DateTime.now().year;
    passingYears = List.generate(
      currentYear - 1980 + 1,
      (index) => (currentYear - index).toString(),
    );
    fetchUserProfile(); // Always fetch fresh data on initialization
    getBranches();
    super.onInit();
  }

  Future<void> fetchUserProfile() async {
    final userId = storage.user.id;
    if (userId == null || userId.isEmpty) return;
    try {
      isLoading.value = true;
      final res = await apiService.get(ApiConstants.getUserById + userId);
      if (res.status == 200 && res.data != null) {
        final user = UserModel.fromJson(res.data);
        await storage.saveUser(user);
        loadUserData();
      } else {
        AppSnackbar.error(res.message ?? 'Failed to refresh profile data');
      }
    } catch (e) {
      log('Error fetching user profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void getBranches() async {
    try {
      final res = await apiService.get(ApiConstants.branches());
      if (res.status == 200) {
        branch.value = (res.data as List<dynamic>)
            .map((e) => BranchModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void loadUserData() {
    final user = storage.user;

    hrNoController.text = user.hrNo ?? "";

    // Normalize Current City logic (Robust handling for non-list cities like 'Mumbai')
    final userCity = user.currentCity?.toLowerCase() ?? 'select';
    if (currentCityList.contains(userCity)) {
      currentCity.value = userCity;
    } else {
      currentCity.value = 'other';
      if (user.currentCity != null && user.currentCity!.isNotEmpty) {
        if (!currentCityList.contains(user.currentCity)) {
          currentCityList.add(user.currentCity!);
        }
        currentCity.value = user.currentCity!;
      }
    }

    // Map Class 10/12 Details
    _mapToClassModel(user.class10, tenTh.value);
    _mapToClassModel(user.class12, twelveTh.value);

    // Map StudyId -> Classes (Optional based on backend schema)
    if (user.studyId?.classes != null) {
      final c = user.studyId!.classes!;
      _mapToClassModelFromStudy(c.class1, class1.value);
      _mapToClassModelFromStudy(c.class2, class2.value);
      _mapToClassModelFromStudy(c.class3, class3.value);
      _mapToClassModelFromStudy(c.class4, class4.value);
      _mapToClassModelFromStudy(c.class5, class5.value);
      _mapToClassModelFromStudy(c.class6, class6.value);
      _mapToClassModelFromStudy(c.class7, class7.value);
      _mapToClassModelFromStudy(c.class8, class8.value);
      _mapToClassModelFromStudy(c.class9, class9.value);
      _mapToClassModelFromStudy(c.class10, class10.value);
      _mapToClassModelFromStudy(c.class11, class11.value);
      _mapToClassModelFromStudy(c.class12, class12.value);
    }
  }

  void _mapToClassModel(Class12Class? data, ClassModel model) {
    if (data == null) return;
    model.isInGurukul.value = data.isStudied == true
        ? ClassStatus.yes
        : (data.isStudied == false ? ClassStatus.no : ClassStatus.notSelected);
    model.branch.value = data.branch ?? "";
    model.passingYear.value = data.passingYear ?? "";
    model.medium.value = data.medium ?? "";
    model.hostel.value = data.hostel == true
        ? "hostel"
        : (data.hostel == false ? "non hostel" : "not Selected");
  }

  // Helper for Class1Class from studyId
  void _mapToClassModelFromStudy(Class1Class? data, ClassModel model) {
    if (data == null) return;
    model.isInGurukul.value = data.isStudied == true
        ? ClassStatus.yes
        : ClassStatus.no;
    model.branch.value = data.branch ?? "";
  }

  Future<void> saveDetails() async {
    final bool isMajorValid =
        majorDetailsFormKey.currentState?.validate() ?? true;
    final bool isClassValid =
        classDetailsFormKey.currentState?.validate() ?? true;

    if (!isMajorValid || !isClassValid) {
      if (!isMajorValid) {
        tab.value = 0;
      } else if (!isClassValid) {
        tab.value = 1;
      }

      AppSnackbar.error("Please correct the errors in the form before saving.");
      return;
    }

    isLoading.value = true;
    try {
      final payload = {
        "userId": storage.user.id,
        "hrNo": hrNoController.text.trim(),
        "currentCity": currentCity.value == "select" ? null : currentCity.value,
        "class10": _mapToPayload(tenTh.value, "10"),
        "class12": _mapToPayload(twelveTh.value, "12"),
        "study": _buildStudyPayload(),
      };

      final ResModel response = await apiService.put(
        ApiConstants.updateUser,
        body: payload,
        headers: {'authorization': storage.token!},
      );

      if (response.status == 200) {
        // Update local session data
        final updatedUser = UserModel.fromJson(response.data);
        await storage.saveUser(updatedUser);

        // Sync in profile list too
        await storage.addProfile(storage.token!, updatedUser);

        AppSnackbar.success("Profile updated successfully!");
        Get.back();
      } else {
        AppSnackbar.error(response.message ?? "Update failed");
      }
    } catch (e) {
      debugPrint("Update error: $e");
      AppSnackbar.error("An unexpected error occurred");
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic>? _buildStudyPayload() {
    final Map<String, dynamic> classesMap = {};

    void addClassIfStudied(String key, ClassModel model) {
      if (model.isInGurukul.value == ClassStatus.yes) {
        classesMap[key] = {"isStudied": true, "branch": model.branch.value};
      }
    }

    addClassIfStudied("class1", class1.value);
    addClassIfStudied("class2", class2.value);
    addClassIfStudied("class3", class3.value);
    addClassIfStudied("class4", class4.value);
    addClassIfStudied("class5", class5.value);
    addClassIfStudied("class6", class6.value);
    addClassIfStudied("class7", class7.value);
    addClassIfStudied("class8", class8.value);
    addClassIfStudied("class9", class9.value);
    addClassIfStudied("class10", class10.value);
    addClassIfStudied("class11", class11.value);
    addClassIfStudied("class12", class12.value);

    return classesMap.isEmpty ? null : classesMap;
  }

  Map<String, dynamic> _mapToPayload(ClassModel model, String classNo) {
    return {
      "class": classNo,
      "isStudied": model.isInGurukul.value == ClassStatus.yes,
      "branch": model.branch.value,
      "passingYear": model.passingYear.value,
      "medium": model.medium.value,
      "hostel": model.hostel.value == "hostel",
    };
  }

  void changeTab(int index) {
    tab.value = index;
  }

  @override
  void onClose() {
    hrNoController.dispose();
    super.onClose();
  }
}
