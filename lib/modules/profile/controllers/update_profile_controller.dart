import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/data/models/branch/branch_model.dart';
import 'package:gurukul_bhutpurva/data/models/class/class_model.dart';
import 'package:gurukul_bhutpurva/data/models/user/user_model.dart';
import 'package:gurukul_bhutpurva/data/models/address/location_model.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:gurukul_bhutpurva/core/mixins/location_dropdown_mixin.dart';

class UpdateProfileController extends GetxController with LocationDropdownMixin {
  final isUpdating = false.obs;
  final isLoading = false.obs;
  final displayImage = ''.obs;

  static UpdateProfileController get instance => Get.find();
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
  String get fullName =>
      "${storage.user.name ?? ''} ${storage.user.fatherName ?? ''} ${storage.user.surname ?? ''}"
          .trim()
          .toUpperCase();

  final nameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final surnameController = TextEditingController();
  final birthDateController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final whatsappNumberController = TextEditingController();
  final gender = 'Male'.obs;

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
  final RxList<Map<String, dynamic>> otherAddressList = <Map<String, dynamic>>[].obs;
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
    'Class Wise Study Details',
    'Address Details',
    'Secondary Details',
    'Skill & Hobbies',
  ];

  final branch = <BranchModel>[].obs;

  final countries = ['India', 'Other'].obs;

  final states = ['Gujarat', 'Other'].obs;

  final currentIndex = 0.obs;

  late PageController pageController;
  late ScrollController tabScrollController;

  final StorageService storage = Get.find();
  final apiService = ApiService.to;

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
    // Start by populating with what we have locally
    _populateData();
    // Then fetch the latest from the server
    fetchUserProfile();
    super.onInit();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      final res = await apiService.get(ApiConstants.getUserById + storage.user.id!);
      if (res.status == 200 && res.data != null) {
        final user = UserModel.fromJson(res.data);
        await storage.saveUser(user);
        _populateData();
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

  void _populateData() {
    final user = storage.user;

    // Header Image
    displayImage.value = user.image ?? '';

    // Primary Details
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

    if (user.createdAt != null) {
      // Assuming createdAt is not DOB, but using it as placeholder for now if DOB is missing in model
      // birthDateController.text = DateFormat('yyyy - MM - dd').format(user.createdAt!);
    }

    // Major Details
    hrNoController.text = user.hrNo ?? '';

    // Normalize Current City
    final userCity = user.currentCity?.toLowerCase() ?? 'select';
    if (currentCityList.contains(userCity)) {
      currentCity.value = userCity;
    } else {
      currentCity.value =
          'other'; // or add to list if you want to support arbitrary cities
      // If valid city but not in list, maybe add it?
      // For now, defaulting to 'other' or keeping as is if we want to show it even if not in dropdown (but dropdown usually requires exact match)
      if (user.currentCity != null && user.currentCity!.isNotEmpty) {
        if (!currentCityList.contains(user.currentCity)) {
          currentCityList.add(user.currentCity!);
        }
        currentCity.value = user.currentCity!;
      }
    }

    // Class Details
    if (user.class10 != null) {
      tenTh.value = _mapClass12ClassToClassModel(user.class10!);
    }
    if (user.class12 != null) {
      twelveTh.value = _mapClass12ClassToClassModel(user.class12!);
    }

    if (user.studyId?.classes?.class1 != null) {
      class1.value = _mapClass1ClassToClassModel(
        user.studyId!.classes!.class1!,
      );
    }
    // class2 to class9 mappings removed as they are not in Classes model

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
          ).then((_) {
            // After prefilling current address
          });
        } else if (type.contains('village') || type.contains('permanent')) {
          prefillAddressEntry(
            villageAddress,
            savedCountry: address.country,
            savedState: address.state,
            savedDistrict: address.district,
            savedCity: address.city,
            fullAddress: address.address,
            pincode: address.pincode,
          ).then((_) {
            // After prefilling village address
          });
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
    if (currentAddress.value.countries.isEmpty) loadCountriesFor(currentAddress);
    if (villageAddress.value.countries.isEmpty) loadCountriesFor(villageAddress);

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

    if (user.professions != null) {
      selectedProfessions.assignAll(user.professions!);
    }

    // Skill & Hobbies
    yourSkill.text = user.skill ?? '';
    if (user.talents != null) {
      selectedTalents.assignAll(user.talents!);
    }
    if (user.awards != null) {
      awards.assignAll(user.awards!);
    }
  }

  ClassModel _mapClass12ClassToClassModel(Class12Class data) {
    final model = ClassModel(
      isInGurukulValue: (data.isStudded ?? false)
          ? ClassStatus.yes
          : ClassStatus.no,
    );

    // Normalize Branch
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

  // Remove _mapAddressIdToAddressModel as we use AddressEntry directly now

  Future<void> updateProfile() async {
    try {
      isUpdating.value = true;
      final user = storage.user;
      final body = {
        "userId": user.id,
        "name": nameController.text,
        "fatherName": fatherNameController.text,
        "surname": surnameController.text,
        "phoneNumber": phoneController.text,
        "whatsappNumber": whatsappNumberController.text,
        "email": emailController.text,
        "gender": gender.value.toLowerCase(),
        "hrNo": hrNoController.text,
        "currentCity": currentCity.value,
        "maritalStatus": maritalStatus.value,
        "bloodGroup": bloodGroup.value,
        "skill": yourSkill.text,
        "professions": selectedProfessions,
        "talents": selectedTalents,
        "awards": awards,
        // Add other fields as needed
        "class10": {
          "isStudded": tenTh.value.isInGurukul.value == ClassStatus.yes,
          "branch": tenTh.value.branch.value,
          "passingYear": tenTh.value.passingYear.value,
          "medium": tenTh.value.medium.value,
          "hostel": tenTh.value.hostel.value == 'hostel',
          "class": "10",
        },
        "class12": {
          "isStudded": twelveTh.value.isInGurukul.value == ClassStatus.yes,
          "branch": twelveTh.value.branch.value,
          "passingYear": twelveTh.value.passingYear.value,
          "medium": twelveTh.value.medium.value,
          "hostel": twelveTh.value.hostel.value == 'hostel',
          "class": "12",
        },
        // Address and other class details mapping...
        "addresses": [
          if (currentAddress.value.selectedCountryName != null)
            {
              "type": "current",
              "address": currentAddress.value.fullAddress,
              "city": currentAddress.value.selectedCityName ?? '',
              "district": currentAddress.value.selectedDistrictName ?? '',
              "state": currentAddress.value.selectedStateName ?? '',
              "country": currentAddress.value.selectedCountryName ?? '',
              "pincode": currentAddress.value.pincode,
            },
          if (villageAddress.value.selectedCountryName != null)
            {
              "type": "village",
              "address": villageAddress.value.fullAddress,
              "city": villageAddress.value.selectedCityName ?? '',
              "district": villageAddress.value.selectedDistrictName ?? '',
              "state": villageAddress.value.selectedStateName ?? '',
              "country": villageAddress.value.selectedCountryName ?? '',
              "pincode": villageAddress.value.pincode,
            },
          // Map otherAddressList...
          ...otherAddressList.map((other) {
            final entry = (other['address'] as Rx<AddressEntry>).value;
            final selectedType = (other['selectedType'] as RxString).value;
            if (entry.selectedCountryName == null) return null;
            return {
              "type": selectedType,
              "address": entry.fullAddress,
              "city": entry.selectedCityName ?? '',
              "district": entry.selectedDistrictName ?? '',
              "state": entry.selectedStateName ?? '',
              "country": entry.selectedCountryName ?? '',
              "pincode": entry.pincode,
            };
          }).where((e) => e != null),
        ],
      };

      final response = await apiService.put(
        ApiConstants.updateUser,
        body: body,
      );

      if (response.status == 200 || response.status == 201) {
        if (response.data != null) {
          final updatedUser = UserModel.fromJson(response.data);
          await storage.saveUser(updatedUser);
          Get.back();
          AppSnackbar.success('Profile updated successfully');
        } else {
          AppSnackbar.error('Failed to update profile');
        }
      } else {
        AppSnackbar.error(response.message ?? 'Failed to update profile');
      }
    } catch (e) {
      log(e.toString());
      AppSnackbar.error('Error updating profile: $e');
    } finally {
      isUpdating.value = false;
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
    otherAddressList.add({
      'selectedType': 'select'.obs,
      'address': entry,
    });
    loadCountriesFor(entry);
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

  void submit() {
    updateProfile();
  }

  @override
  void onClose() {
    pageController.dispose();
    tabScrollController.dispose();
    super.onClose();
  }
}
