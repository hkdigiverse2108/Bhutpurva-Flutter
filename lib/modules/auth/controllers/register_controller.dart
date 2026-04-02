import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/core/mixins/location_dropdown_mixin.dart';
import 'package:gurukul_bhutpurva/data/models/address/location_model.dart';
import 'package:gurukul_bhutpurva/data/models/branch/branch_model.dart';
import 'package:gurukul_bhutpurva/data/models/class/class_model.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:intl/intl.dart';

class RegisterController extends GetxController with LocationDropdownMixin {
  static RegisterController get instance => Get.find();
  final apiService = ApiService.to;
  final storage = Get.find<StorageService>();

  final Map<String, String> talentTranslations = {
    'Reading': 'વાંચન',
    'Writing': 'લેખન',
    'Speech': 'પ્રવચન',
    'Acting': 'અભિનય',
    'Dancing': 'નૃત્ય',
    'Singing': 'ગાયન',
    'Anchoring': 'સભા સંચાલન',
    'Instrument': 'વાદન કલા',
  };

  // Primary Details
  final nameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final surnameController = TextEditingController();
  final birthDateController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final whatsappNumberController = TextEditingController();
  final gender = 'Male'.obs;

  final isLoading = false.obs;

  // Major Details
  final hrNoController = TextEditingController(text: 'Major HR No');
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

  // Address Details
  final currentAddress = AddressEntry().obs;
  final villageAddress = AddressEntry().obs;

  final List<String> addressType = [
    'factory',
    'shop',
    'office',
    'business',
  ].obs;
  final List<Rx<AddressEntry>> otherAddressList = <Rx<AddressEntry>>[].obs;
  final currentCityList = <String>['select', 'surat', 'other'].obs;

  late final List<String> passingYears;
  late final List<String> hostels = [
    'not Selected',
    'hostel',
    'non hostel',
  ].obs;

  // Secondary Details
  final isStudent = false.obs;
  final isBusiness = false.obs;
  final isEmployee = false.obs;
  final isSelfEmployee = false.obs;
  final isRetired = false.obs;
  final allProfessions = <String>[].obs;
  final RxList<String> selectedProfessions = <String>[].obs;
  final otherProfession = TextEditingController();
  final allEducations = <String>[].obs;
  final RxList<String> selectedEducations = <String>[].obs;
  final otherEducation = TextEditingController();
  final maritalStatus = 'Not Selected'.obs;
  final bloodGroup = 'Select'.obs;

  final maritalStatusList = ['Single', 'Married', 'Divorced', 'Widowed'].obs;

  final bloodGroupList = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'].obs;

  // Skill & Hobbies
  final yourSkill = TextEditingController();
  final yourHobbies = TextEditingController();
  final yourAwards = TextEditingController();
  final instrumentController = TextEditingController();
  final awards = [].obs;
  final talents = [
    'Reading',
    'Writing',
    'Speech',
    'Acting',
    'Dancing',
    'Singing',
    'Anchoring',
    'Instrument',
  ].obs;
  final instruments = [].obs;
  final selectedTalents = [].obs;

  final isWhatsappNumber = true.obs;
  final primaryDetailsFormKey = GlobalKey<FormState>();
  final majorDetailsFormKey = GlobalKey<FormState>();
  final classDetailsFormKey = GlobalKey<FormState>();
  final addressDetailsFormKey = GlobalKey<FormState>();
  final secondaryDetailsFormKey = GlobalKey<FormState>();
  final skillAndHobbiesFormKey = GlobalKey<FormState>();

  List<String> tabs = [
    'Primary Details',
    'Major Details',
    'Address Details',
    'Secondary Details',
    'Class Wise Study Details',
    'Skill & Hobbies',
  ];

  final branch = <BranchModel>[].obs;

  final countries = ['India', 'Other'].obs;

  final states = ['Gujarat', 'Other'].obs;

  final currentIndex = 0.obs;

  late PageController pageController;
  late ScrollController tabScrollController;

  @override
  void onInit() {
    pageController = PageController();
    tabScrollController = ScrollController();

    final currentYear = DateTime.now().year;
    passingYears = List.generate(
      currentYear - 1990 + 1,
      (index) => (currentYear - index).toString(),
    );
    loadCountriesFor(currentAddress);
    loadCountriesFor(villageAddress);
    getBranches();
    super.onInit();
  }

  void getBranches() async {
    try {
      final res = await apiService.get(ApiConstants.branches());
      if (res.statusCode == 200) {
        branch.value = (res.data as List<dynamic>)
            .map((e) => BranchModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void onTabTap(int index) {
    if (index > currentIndex.value) {
      if (!validateCurrentStep()) return;
    }
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
    scrollToTab(index);
  }

  void openSelectionDialog({
    required BuildContext context,
    required String title,
    required List<String> items,
    String? selectedValue,
    required Function(String value) onSelected,
  }) {
    final searchController = TextEditingController();
    final filteredItems = ValueNotifier<List<String>>(items);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Search
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  filteredItems.value = items
                      .where(
                        (e) => e.toLowerCase().contains(value.toLowerCase()),
                      )
                      .toList();
                },
              ),

              const SizedBox(height: 12),

              /// List
              Expanded(
                child: ValueListenableBuilder<List<String>>(
                  valueListenable: filteredItems,
                  builder: (_, list, __) {
                    if (list.isEmpty) {
                      return const Center(child: Text('No results found'));
                    }

                    return ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: Colors.grey.shade200),
                      itemBuilder: (_, index) {
                        final item = list[index];
                        final isSelected = item == selectedValue;

                        return ListTile(
                          title: Text(item),
                          trailing: isSelected
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () {
                            onSelected(item);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      birthDateController.text = DateFormat('yyyy - MM - dd').format(picked);
      return birthDateController.text;
    } else {
      return null;
    }
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
    scrollToTab(index);
  }

  void scrollToTab(int index) {
    const tabWidth = 160.0; // IMPORTANT (same as tab width)
    final screenWidth = Get.width;

    final offset = (index * tabWidth) - (screenWidth / 2) + (tabWidth / 2);

    tabScrollController.animateTo(
      offset.clamp(
        tabScrollController.position.minScrollExtent,
        tabScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  void addOtherAddress() {
    final entry = AddressEntry().obs;
    loadCountriesFor(entry);
    otherAddressList.add(entry);
  }

  void removeOtherAddress(int index) {
    otherAddressList.removeAt(index);
  }

  void toggleProfession(String profession) {
    if (selectedProfessions.contains(profession)) {
      selectedProfessions.remove(profession);
    } else {
      selectedProfessions.add(profession);
    }
  }

  void removeProfession(String profession) {
    selectedProfessions.remove(profession);
  }

  void toggleEducation(String education) {
    if (selectedEducations.contains(education)) {
      selectedEducations.remove(education);
    } else {
      selectedEducations.add(education);
    }
  }

  void removeEducation(String education) {
    selectedEducations.remove(education);
  }

  void addInstrument() {
    if (instrumentController.text == "") {
      return;
    }
    instruments.add(instrumentController.text);
    instrumentController.clear();
  }

  void addAwards() {
    if (yourAwards.text == "") {
      return;
    }
    awards.add(yourAwards.text);
    yourAwards.clear();
  }

  void removeAwards(String value) {
    awards.remove(value);
  }

  void removeInstrument(String index) {
    instruments.remove(index);
  }

  void toggleTalent(String talent) {
    if (selectedTalents.contains(talent)) {
      selectedTalents.remove(talent);
    } else {
      selectedTalents.add(talent);
    }
  }

  bool validateCurrentStep() {
    switch (currentIndex.value) {
      case 0:
        return primaryDetailsFormKey.currentState?.validate() ?? true;
      case 1:
        return majorDetailsFormKey.currentState?.validate() ?? true;
      case 2:
        return addressDetailsFormKey.currentState?.validate() ?? true;
      case 3:
        return secondaryDetailsFormKey.currentState?.validate() ?? true;
      case 4:
        return classDetailsFormKey.currentState?.validate() ?? true;
      case 5:
        return skillAndHobbiesFormKey.currentState?.validate() ?? true;
      default:
        return true;
    }
  }

  void submit() async {
    if (!validateCurrentStep()) {
      return;
    }
    try {
      isLoading.value = true;

      // 1. Build Study Map (Pattern #2)
      final studyPayload = {
        if (class1.value.isInGurukul.value == ClassStatus.yes)
          "class1": {"isStudied": true, "branch": class1.value.branch.value},
        if (class2.value.isInGurukul.value == ClassStatus.yes)
          "class2": {"isStudied": true, "branch": class2.value.branch.value},
        if (class3.value.isInGurukul.value == ClassStatus.yes)
          "class3": {"isStudied": true, "branch": class3.value.branch.value},
        if (class4.value.isInGurukul.value == ClassStatus.yes)
          "class4": {"isStudied": true, "branch": class4.value.branch.value},
        if (class5.value.isInGurukul.value == ClassStatus.yes)
          "class5": {"isStudied": true, "branch": class5.value.branch.value},
        if (class6.value.isInGurukul.value == ClassStatus.yes)
          "class6": {"isStudied": true, "branch": class6.value.branch.value},
        if (class7.value.isInGurukul.value == ClassStatus.yes)
          "class7": {"isStudied": true, "branch": class7.value.branch.value},
        if (class8.value.isInGurukul.value == ClassStatus.yes)
          "class8": {"isStudied": true, "branch": class8.value.branch.value},
        if (class9.value.isInGurukul.value == ClassStatus.yes)
          "class9": {"isStudied": true, "branch": class9.value.branch.value},
        if (class10.value.isInGurukul.value == ClassStatus.yes)
          "class10": {"isStudied": true, "branch": class10.value.branch.value},
        if (class11.value.isInGurukul.value == ClassStatus.yes)
          "class11": {"isStudied": true, "branch": class11.value.branch.value},
        if (class12.value.isInGurukul.value == ClassStatus.yes)
          "class12": {"isStudied": true, "branch": class12.value.branch.value},
      };

      // 2. Format Birth Date (Pattern #6)
      String? birthDateIso;
      if (birthDateController.text.isNotEmpty) {
        try {
          birthDateIso = DateFormat(
            'yyyy - MM - dd',
          ).parse(birthDateController.text).toIso8601String();
        } catch (e) {
          log('Error parsing birthDate: $e');
        }
      }

      final tenth = {
        "class": "10",
        "isStudied":
            tenTh.value.isInGurukul.value == ClassStatus.yes, // Pattern #3
        "branch": tenTh.value.branch.value,
        "passingYear": tenTh.value.passingYear.value,
        "medium": tenTh.value.medium.value,
        "hostel": tenTh.value.hostel.value == 'hostel',
      };

      final twelfth = {
        "class": "12",
        "isStudied":
            twelveTh.value.isInGurukul.value == ClassStatus.yes, // Pattern #3
        "branch": twelveTh.value.branch.value,
        "passingYear": twelveTh.value.passingYear.value,
        "medium": twelveTh.value.medium.value,
        "hostel": twelveTh.value.hostel.value == 'hostel',
      };

      final Map<String, dynamic> body = {
        "name": nameController.text,
        "fatherName": fatherNameController.text,
        "surname": surnameController.text,
        "email": emailController.text,
        "role": "user",
        "birthDate": birthDateIso,
        "phoneNumber": phoneController.text,
        "whatsappNumber": whatsappNumberController.text,
        "gender": gender.value.toLowerCase(),
        "hrNo": hrNoController.text,
        "currentCity": currentCity.value,
        "addresses": _buildAddressesPayload(),
        "professions": selectedProfessions.toList(), // Pattern #4
        "education": selectedEducations.toList(), // Pattern #4
        "maritalStatus": maritalStatus.value,
        "bloodGroup": bloodGroup.value,
        "study": studyPayload.isEmpty ? null : studyPayload, // Pattern #2
        "skill": yourSkill.text, // Pattern #4
        "hobbies": yourHobbies.text, // Pattern #4
        "talents": selectedTalents.toList(),
        "awards": awards.toList(),
        "class10": tenth,
        "class12": twelfth,
      };

      final ResModel response = await apiService.post(
        ApiConstants.register,
        body: body,
      );

      if (response.status == 200) {
        Get.toNamed(AppRoutes.login);
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> _buildAddressesPayload() {
    final list = <Map<String, dynamic>>[];

    Map<String, dynamic>? buildMap(AddressEntry entry, String type) {
      if (entry.selectedCountryName == null) {
        return null;
      }
      return {
        "type": type, // Pattern #1: Use 'type' not 'addressType'
        "address": entry.fullAddress,
        "city": entry.selectedCityName ?? "",
        "district": entry.selectedDistrictName ?? "",
        "state": entry.selectedStateName ?? "",
        "country": entry.selectedCountryName ?? "",
        "pincode": entry.pincode,
      };
    }

    final current = buildMap(currentAddress.value, "current");
    if (current != null) {
      list.add(current);
    }

    final village = buildMap(villageAddress.value, "village");
    if (village != null) {
      list.add(village);
    }

    for (var i = 0; i < otherAddressList.length; i++) {
      final other = buildMap(otherAddressList[i].value, "other");
      if (other != null) {
        list.add(other);
      }
    }

    return list;
  }

  @override
  void onClose() {
    pageController.dispose();
    tabScrollController.dispose();
    super.onClose();
  }
}
