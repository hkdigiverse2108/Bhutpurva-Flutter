import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/data/models/address/address_model.dart';
import 'package:gurukul_bhutpurva/data/models/class/class_model.dart';
import 'package:intl/intl.dart';

class MemberUpdateController extends GetxController {
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
  final currentAddress = AddressModel().obs;
  final villageAddress = AddressModel().obs;
  final List<Rx<AddressModel>> otherAddressList = <Rx<AddressModel>>[].obs;
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

  final branch = [
    'surat Gurukul',
    'bharuch Gurukul',
    'jasdan Gurukul',
    'una Gurukul',
    'new delhi Gurukul',
  ].obs;

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

    // Initialize with member data if provided
    final memberData = Get.arguments;

    if (storageService.isLeader || storageService.isConvener) {
      hasEditAccess.value = true;
    }

    final currentYear = DateTime.now().year;
    passingYears = List.generate(
      currentYear - 1990 + 1,
      (index) => (currentYear - index).toString(),
    );

    super.onInit();
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
    otherAddressList.add(AddressModel().obs);
  }

  void removeOtherAddress(int index) {
    otherAddressList.removeAt(index);
  }

  void submit() {
    Get.back();
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
