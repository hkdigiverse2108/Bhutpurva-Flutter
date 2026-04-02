import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/core/mixins/location_dropdown_mixin.dart';
import 'package:gurukul_bhutpurva/data/models/address/location_model.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/data/models/branch/branch_model.dart';
import 'package:gurukul_bhutpurva/data/models/class/class_model.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/data/models/user/user_model.dart';
import 'package:gurukul_bhutpurva/data/models/member/member_model.dart';
import 'package:intl/intl.dart';

class MemberUpdateController extends GetxController with LocationDropdownMixin {
  static MemberUpdateController get instance => Get.find();

  final storageService = Get.find<StorageService>();

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

  // New fields for member update
  final hasEditAccess = false.obs;
  final isVerified = false.obs;
  final isLoading = false.obs;
  String? targetUserId;
  UserModel? _currentUser;

  late final List<String> passingYears;
  late final List<String> hostels = [
    'not Selected',
    'hostel',
    'non hostel',
  ].obs;

  // Primary Details
  final nameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final surnameController = TextEditingController();
  final birthDateController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final whatsappNumberController = TextEditingController();
  final gender = 'Male'.obs;
  final displayImage = ''.obs;

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
  final RxList<Map<String, dynamic>> otherAddressList =
      <Map<String, dynamic>>[].obs;
  final currentCityList = <String>['select', 'surat', 'other'].obs;

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
  final bloodGroup = 'Not Selected'.obs;
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

  final countries = ['India', 'Other'].obs;

  final states = ['Gujarat', 'Other'].obs;

  // Form Keys
  final isWhatsappNumber = true.obs;
  final primaryDetailsFormKey = GlobalKey<FormState>();
  final majorDetailsFormKey = GlobalKey<FormState>();
  final classDetailsFormKey = GlobalKey<FormState>();
  final addressDetailsFormKey = GlobalKey<FormState>();
  final secondaryDetailsFormKey = GlobalKey<FormState>();
  final skillAndHobbiesFormKey = GlobalKey<FormState>();

  // Tabs
  final tabs = [
    'Primary Details',
    'Major Details',
    'Address Details',
    'Secondary Details',
    'Class Wise Study Details',
    'Skill & Hobbies',
  ];

  final branch = <BranchModel>[].obs;

  final List<String> addressType = [
    'factory',
    'shop',
    'office',
    'business',
  ].obs;

  final currentIndex = 0.obs;
  late PageController pageController;
  late ScrollController tabScrollController;

  @override
  void onInit() {
    pageController = PageController();
    tabScrollController = ScrollController();

    final dynamic memberData = Get.arguments;

    if (memberData is UserModel) {
      targetUserId = memberData.id;
      _fetchMemberDetails(memberData.id!);
    } else if (memberData is String && memberData.isNotEmpty) {
      targetUserId = memberData;
      _fetchMemberDetails(memberData);
    } else if (memberData is MemberModel) {
      targetUserId = memberData.id;
      _fetchMemberDetails(memberData.id);
    } else {
      loadCountriesFor(currentAddress);
      loadCountriesFor(villageAddress);
    }

    if (storageService.isLeader || storageService.isConvener) {
      hasEditAccess.value = true;
    }

    final currentYear = DateTime.now().year;
    passingYears = List.generate(
      currentYear - 1990 + 1,
      (index) => (currentYear - index).toString(),
    );

    getBranches();

    super.onInit();
  }

  Future<void> _fetchMemberDetails(String id) async {
    try {
      isLoading.value = true;
      final res = await apiService.get(ApiConstants.getUserById + id);
      if (res.status == 200 && res.data != null) {
        final user = UserModel.fromJson(res.data);
        _currentUser = user; // Store the user for address ID matching
        _populateFields(user);
      } else {
        Get.snackbar(
          'Error',
          res.message ?? 'Failed to fetch member details',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log('Error fetching member details: $e');
      Get.snackbar(
        'Error',
        'Something went wrong while fetching member data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _populateFields(UserModel user) async {
    _currentUser = user; // Ensure it's set if called directly
    // 1. Primary Details
    displayImage.value = user.image ?? '';
    nameController.text = user.name ?? '';
    fatherNameController.text = user.fatherName ?? '';
    surnameController.text = user.surname ?? '';

    // Birth Date Display Formatting (Pattern #5 & #6)
    if (user.birthDate != null) {
      birthDateController.text = DateFormat(
        'yyyy - MM - dd',
      ).format(user.birthDate!);
    } else {
      birthDateController.text = '';
    }

    phoneController.text = user.phoneNumber ?? '';
    emailController.text = user.email ?? '';
    whatsappNumberController.text = user.whatsappNumber ?? '';

    // Normalize Gender
    final userGender = user.gender?.toLowerCase() ?? 'male';
    if (userGender == 'female') {
      gender.value = 'Female';
    } else if (userGender == 'other') {
      gender.value = 'Other';
    } else {
      gender.value = 'Male';
    }

    isVerified.value = user.isVerified ?? false;

    // 2. Major Details
    hrNoController.text = user.hrNo ?? '';

    // Normalize Current City
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

    // Classes 1-12 (Pattern #5: Study map base)
    if (user.studyId?.classes != null) {
      final c = user.studyId!.classes!;
      if (c.class1 != null) {
        class1.value = _mapClass1ClassToClassModel(c.class1!);
      }
      if (c.class2 != null) {
        class2.value = _mapClass1ClassToClassModel(c.class2!);
      }
      if (c.class3 != null) {
        class3.value = _mapClass1ClassToClassModel(c.class3!);
      }
      if (c.class4 != null) {
        class4.value = _mapClass1ClassToClassModel(c.class4!);
      }
      if (c.class5 != null) {
        class5.value = _mapClass1ClassToClassModel(c.class5!);
      }
      if (c.class6 != null) {
        class6.value = _mapClass1ClassToClassModel(c.class6!);
      }
      if (c.class7 != null) {
        class7.value = _mapClass1ClassToClassModel(c.class7!);
      }
      if (c.class8 != null) {
        class8.value = _mapClass1ClassToClassModel(c.class8!);
      }
      if (c.class9 != null) {
        class9.value = _mapClass1ClassToClassModel(c.class9!);
      }
      if (c.class10 != null) {
        class10.value = _mapClass1ClassToClassModel(c.class10!);
      }
      if (c.class11 != null) {
        class11.value = _mapClass1ClassToClassModel(c.class11!);
      }
      if (c.class12 != null) {
        class12.value = _mapClass1ClassToClassModel(c.class12!);
      }
    }

    // Classes 10 & 12 (Pattern #5: Detailed override)
    if (user.class10 != null) {
      final mapped = _mapClass12ClassToClassModel(user.class10!);
      class10.value = mapped;
      tenTh.value = _mapClass12ClassToClassModel(user.class10!);
    }
    if (user.class12 != null) {
      final mapped = _mapClass12ClassToClassModel(user.class12!);
      class12.value = mapped;
      twelveTh.value = _mapClass12ClassToClassModel(user.class12!);
    }

    // 3. Address Details (Pattern #5: clear lists first)
    otherAddressList.clear();

    if (user.addressIds != null) {
      for (var address in user.addressIds!) {
        final type = address.type?.toLowerCase() ?? '';
        if (type.contains('current')) {
          prefillAddressEntry(
            currentAddress,
            savedCountry: address.country,
            savedState: address.state,
            savedDistrict: address.district,
            savedCity: address.city,
            fullAddress: address.address,
            pincode: address.pincode,
          ).then((_) {});
        } else if (type.contains('village') || type.contains('permanent')) {
          prefillAddressEntry(
            villageAddress,
            savedCountry: address.country,
            savedState: address.state,
            savedDistrict: address.district,
            savedCity: address.city,
            fullAddress: address.address,
            pincode: address.pincode,
          ).then((_) {});
        } else {
          final newOther = AddressEntry().obs;
          otherAddressList.add({
            'selectedType': address.type?.obs ?? 'not Selected'.obs,
            'address': newOther,
          });
          prefillAddressEntry(
            newOther,
            savedCountry: address.country,
            savedState: address.state,
            savedDistrict: address.district,
            savedCity: address.city,
            fullAddress: address.address,
            pincode: address.pincode,
          );
        }
      }
    }

    // Load countries for unused form addresses just in case they weren't prefilled
    if (currentAddress.value.countries.isEmpty) {
      loadCountriesFor(currentAddress);
    }
    if (villageAddress.value.countries.isEmpty) {
      loadCountriesFor(villageAddress);
    }

    // 4. Secondary Details
    // Normalize Marital Status
    final userMarital = user.maritalStatus;
    if (userMarital != null && ['Married', 'Unmarried'].contains(userMarital)) {
      maritalStatus.value = userMarital;
    } else {
      maritalStatus.value = 'Not Selected';
    }

    // Normalize Blood Group
    final userBlood = user.bloodGroup;
    final validBloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
    if (userBlood != null && validBloodGroups.contains(userBlood)) {
      bloodGroup.value = userBlood;
    } else {
      bloodGroup.value = 'Not Selected';
    }

    selectedProfessions.assignAll(user.professions ?? []);

    // Populate selectedEducations from user.educations (Pattern #5)
    if (user.educations != null) {
      selectedEducations.assignAll(
        user.educations!.map((e) => e.toString()).toList(),
      );
    }

    // 5. Skill & Hobbies
    yourSkill.text = user.skill ?? '';
    yourHobbies.text =
        user.hobbies ?? ''; // Pattern #5: Added hobbies population
    selectedTalents.assignAll(user.talents ?? []);
    awards.assignAll(user.awards ?? []);
  }

  ClassModel _mapClass12ClassToClassModel(Class12Class data) {
    final model = ClassModel(
      isInGurukulValue: (data.isStudied ?? false)
          ? ClassStatus.yes
          : ClassStatus.no,
    );

    if (data.branch != null) {
      model.branch.value = data.branch!;
    }

    model.passingYear.value = data.passingYear;
    model.medium.value = data.medium;
    model.hostel.value = (data.hostel ?? false) ? 'hostel' : 'non hostel';
    return model;
  }

  ClassModel _mapClass1ClassToClassModel(Class1Class data) {
    final model = ClassModel(
      isInGurukulValue: (data.isStudied ?? false)
          ? ClassStatus.yes
          : ClassStatus.no,
    );
    if (data.branch != null) {
      model.branch.value = data.branch!;
    }
    return model;
  }

  final apiService = ApiService.to;

  void getBranches() async {
    try {
      final res = await apiService.get(ApiConstants.branches());
      if (res.status == 200) {
        branch.value = (res.data as List<dynamic>)
            .map((e) => BranchModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      log(
        DateFormat.yMd().format(DateTime.now()),
      ); // Just a placeholder for logging
    }
  }

  void onTabTap(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
    scrollToTab(index);
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
    scrollToTab(index);
  }

  void scrollToTab(int index) {
    const tabWidth = 160.0;
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
    otherAddressList.add({'selectedType': 'select'.obs, 'address': entry});
    loadCountriesFor(entry);
  }

  void removeOtherAddress(int index) {
    if (index >= 0 && index < otherAddressList.length) {
      otherAddressList.removeAt(index);
    }
  }

  void submit() async {
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

      final payload = {
        'userId': targetUserId,
        'name': nameController.text,
        'fatherName': fatherNameController.text,
        'surname': surnameController.text,
        'birthDate': birthDateIso, // Pattern #6
        'phoneNumber': phoneController.text,
        'email': emailController.text,
        'whatsappNumber': whatsappNumberController.text,
        'gender': gender.value.toLowerCase(),
        'hrNo': hrNoController.text,
        'currentCity': currentCity.value,
        'maritalStatus': maritalStatus.value,
        'bloodGroup': bloodGroup.value,
        'skill': yourSkill.text,
        'hobbies': yourHobbies.text, // Pattern #4
        'professions': selectedProfessions.toList(), // Pattern #4
        'education': selectedEducations.toList(), // Pattern #4
        'talents': selectedTalents.toList(),
        'awards': awards.toList(),
        "study": studyPayload.isEmpty ? null : studyPayload, // Pattern #2
        'class10': _mapControllerToApiClass(class10.value, '10'),
        'class12': _mapControllerToApiClass(class12.value, '12'),
        'addresses': _collectAddresses(),
      };

      final res = await apiService.put(ApiConstants.updateUser, body: payload);
      if (res.status == 200) {
        Get.back();
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          res.message ?? 'Update failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log('Error updating profile: $e');
      Get.snackbar(
        'Error',
        'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _mapControllerToApiClass(
    ClassModel c,
    String className,
  ) {
    return {
      'class': className,
      'isStudied': c.isInGurukul.value == ClassStatus.yes, // Pattern #3
      'branch': c.branch.value,
      'passingYear': c.passingYear.value,
      'medium': c.medium.value,
      'hostel': c.hostel.value == 'hostel',
    };
  }

  List<Map<String, dynamic>> _collectAddresses() {
    final List<Map<String, dynamic>> addressList = [];

    // Pattern #1: Match IDs from user data
    // Important: We need the original user data to get the address IDs.
    // However, MemberUpdateController doesn't keep the full user model.
    // It only gets it in _populateFields. I should probably store it.

    // For now, I will use a placeholder or assume that if we are updating,
    // we should have the user model.

    // Wait, targetUserId is present. I should have kept the user model.
    // Let me check if I can get user from somewhere.
    // Ah, I see how UpdateProfileController does it: it has 'storage.user'.
    // Here we need to store the user in _populateFields.

    // Let me add 'UserModel? _currentUser;' to the controller.

    // Current Address
    if (currentAddress.value.selectedCountryName != null) {
      final id = _currentUser?.addressIds
          ?.firstWhereOrNull((a) => a.type?.toLowerCase() == 'current')
          ?.id;
      addressList.add(_buildAddressMap(currentAddress.value, 'current', id));
    }

    // Village Address
    if (villageAddress.value.selectedCountryName != null) {
      final id = _currentUser?.addressIds
          ?.firstWhereOrNull(
            (a) =>
                a.type?.toLowerCase() == 'village' ||
                a.type?.toLowerCase() == 'permanent',
          )
          ?.id;
      addressList.add(_buildAddressMap(villageAddress.value, 'village', id));
    }

    // Other Addresses
    for (var i = 0; i < otherAddressList.length; i++) {
      final other = otherAddressList[i];
      final entry = (other['address'] as Rx<AddressEntry>).value;
      final type = (other['selectedType'] as Rx<String>).value;

      if (type != 'select' && entry.selectedCountryName != null) {
        // Match by index for other addresses (Pattern #1)
        final otherAddresses = _currentUser?.addressIds
            ?.where(
              (a) => !([
                'current',
                'village',
                'permanent',
              ].contains(a.type?.toLowerCase() ?? '')),
            )
            .toList();

        String? id;
        if (otherAddresses != null && i < otherAddresses.length) {
          id = otherAddresses[i].id;
        }

        addressList.add(_buildAddressMap(entry, type, id));
      }
    }

    return addressList;
  }

  Map<String, dynamic> _buildAddressMap(
    AddressEntry entry,
    String type,
    String? id,
  ) {
    return {
      if (id != null) 'id': id, // Pattern #1: Include ID
      'address': entry.fullAddress,
      'type': type,
      'city': entry.selectedCityName ?? '',
      'district': entry.selectedDistrictName ?? '',
      'state': entry.selectedStateName ?? '',
      'country': entry.selectedCountryName ?? '',
      'pincode': entry.pincode,
    };
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

  void toggleTalent(String talent) {
    if (selectedTalents.contains(talent)) {
      selectedTalents.remove(talent);
    } else {
      selectedTalents.add(talent);
    }
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

  @override
  void onClose() {
    nameController.dispose();
    fatherNameController.dispose();
    surnameController.dispose();
    birthDateController.dispose();
    phoneController.dispose();
    emailController.dispose();
    whatsappNumberController.dispose();
    hrNoController.dispose();
    otherProfession.dispose();
    otherEducation.dispose();
    yourSkill.dispose();
    yourHobbies.dispose();
    yourAwards.dispose();
    instrumentController.dispose();
    pageController.dispose();
    tabScrollController.dispose();
    super.onClose();
  }
}
