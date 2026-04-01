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
      _populateFields(memberData);
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
        _populateFields(UserModel.fromJson(res.data));
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
    // Primary Details
    displayImage.value = user.image ?? '';
    nameController.text = user.name ?? '';
    fatherNameController.text = user.fatherName ?? '';
    surnameController.text = user.surname ?? '';
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

    // Major Details
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

    // Classes
    if (user.class10 != null) {
      class10.value = _mapClass12ClassToClassModel(user.class10!);
    }
    if (user.class12 != null) {
      class12.value = _mapClass12ClassToClassModel(user.class12!);
    }

    if (user.studyId?.classes?.class1 != null) {
      class1.value = _mapClass1ClassToClassModel(
        user.studyId!.classes!.class1!,
      );
    }
    if (user.studyId?.classes?.class10 != null) {
      class10.value = _mapClass1ClassToClassModel(
        user.studyId!.classes!.class10!,
      );
    }

    // Address Details
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

    // Secondary Details
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
    selectedEducations.assignAll(
      user.educations?.map((e) => e.toString()).toList() ?? [],
    );

    // Skill & Hobbies
    yourSkill.text = user.skill ?? '';
    selectedTalents.assignAll(user.talents ?? []);
    awards.assignAll(user.awards ?? []);
  }

  ClassModel _mapClass12ClassToClassModel(Class12Class data) {
    final model = ClassModel(
      isInGurukulValue: (data.isStudded ?? false)
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
      final payload = {
        'userId': targetUserId,
        'name': nameController.text,
        'fatherName': fatherNameController.text,
        'surname': surnameController.text,
        'phoneNumber': phoneController.text,
        'email': emailController.text,
        'whatsappNumber': whatsappNumberController.text,
        'gender': gender.value.toLowerCase(),
        'hrNo': hrNoController.text,
        'currentCity': currentCity.value,
        'maritalStatus': maritalStatus.value,
        'bloodGroup': bloodGroup.value,
        'skill': yourSkill.text,
        'professions': selectedProfessions,
        'educations': selectedEducations,
        'talents': selectedTalents,
        'awards': awards,
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
    }
  }

  Map<String, dynamic> _mapControllerToApiClass(
    ClassModel c,
    String className,
  ) {
    return {
      'class': className,
      'isStudded': c.isInGurukul.value == ClassStatus.yes,
      'branch': c.branch.value,
      'passingYear': c.passingYear.value,
      'medium': c.medium.value,
      'hostel': c.hostel.value == 'hostel',
    };
  }

  List<Map<String, dynamic>> _collectAddresses() {
    final List<Map<String, dynamic>> addressList = [];

    // Current Address
    if (currentAddress.value.selectedCountryName != null) {
      addressList.add(_buildAddressMap(currentAddress.value, 'current'));
    }

    // Village Address
    if (villageAddress.value.selectedCountryName != null) {
      addressList.add(_buildAddressMap(villageAddress.value, 'village'));
    }

    // Other Addresses
    for (var other in otherAddressList) {
      final entry = (other['address'] as Rx<AddressEntry>).value;
      final type = (other['selectedType'] as Rx<String>).value;
      if (type != 'select' && entry.selectedCountryName != null) {
        addressList.add(_buildAddressMap(entry, type));
      }
    }

    return addressList;
  }

  Map<String, dynamic> _buildAddressMap(AddressEntry entry, String type) {
    return {
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
    pageController.dispose();
    tabScrollController.dispose();
    super.onClose();
  }
}
