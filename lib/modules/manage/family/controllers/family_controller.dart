import 'dart:developer';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class FamilyMemberLocal {
  final String memberId;
  final String name;
  final String phone;
  final String image;
  String relationship;

  FamilyMemberLocal({
    required this.memberId,
    required this.name,
    required this.phone,
    required this.image,
    required this.relationship,
  });

  Map<String, dynamic> toJson() => {
    "memberId": memberId,
    "relationship": relationship.toLowerCase(),
  };
}

class FamilyController extends GetxController {
  final apiService = ApiService.to;
  final storageService = Get.find<StorageService>();

  final familyMembers = <FamilyMemberLocal>[].obs;
  final RxString? familyId = RxString('');
  final RxBool isLoading = false.obs;

  final relation = ''.obs;
  final countryCode = '+91'.obs;
  final isoCode = 'IN'.obs;
  final countryFlag = '🇮🇳'.obs;
  final mobileController = TextEditingController();
  final phoneError = ''.obs;

  final relations = [
    'Father',
    'Mother',
    'Brother',
    'Sister',
    'Uncle',
    'Aunt',
    'Cousin',
    'Grandmother',
    'Grandfather',
    'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    getFamily();
  }

  void selectCountry(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        countryCode.value = '+${country.phoneCode}';
        isoCode.value = country.countryCode;
        countryFlag.value = country.flagEmoji;
        phoneError.value = '';
      },
    );
  }

  bool validatePhone() {
    try {
      final phone = PhoneNumber.parse(
        mobileController.text,
        destinationCountry: IsoCode.fromJson(isoCode.value),
      );

      if (!phone.isValid()) {
        phoneError.value = 'Invalid phone number for selected country';
        return false;
      }

      phoneError.value = '';
      return true;
    } catch (_) {
      phoneError.value = 'Invalid phone number format';
      return false;
    }
  }

  void openAddMemberDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const Text(
              'Add Family Member',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Obx(
              () => DropdownButtonFormField<String>(
                initialValue: relation.value.isEmpty ? null : relation.value,
                items: relations
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => relation.value = value ?? '',
                decoration: InputDecoration(
                  labelText: 'Relation',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                GestureDetector(
                  onTap: () => selectCountry(Get.context!),
                  child: Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            countryFlag.value,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            countryCode.value,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Mobile number',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Obx(
              () => phoneError.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 6, left: 4),
                      child: Text(
                        phoneError.value,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: searchMember,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Search Member',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void getFamily() async {
    try {
      isLoading.value = true;
      final ResModel res = await apiService.get(ApiConstants.getFamily);
      if (res.status == 200) {
        familyId?.value = res.data['_id'];
        final List membersData = res.data['members'] ?? [];
        familyMembers.assignAll(
          membersData.map((m) {
            final dynamic memberIdVal = m['memberId'];

            if (memberIdVal is Map) {
              return FamilyMemberLocal(
                memberId: memberIdVal['_id']?.toString() ?? '',
                name: memberIdVal['name'] ?? '',
                phone: memberIdVal['phoneNumber'] ?? '',
                image: memberIdVal['image'] ?? '',
                relationship: m['relationship'] ?? 'other',
              );
            } else {
              return FamilyMemberLocal(
                memberId: memberIdVal?.toString() ?? '',
                name: 'Family Member',
                phone: '',
                image: '',
                relationship: m['relationship'] ?? 'other',
              );
            }
          }).toList(),
        );
      }
    } catch (e) {
      log("Error fetching family: $e");
      familyId?.value = '';
      familyMembers.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void searchMember() async {
    if (relation.value.isEmpty) {
      AppSnackbar.error('Please select relation');
      return;
    }

    if (mobileController.text.isEmpty) {
      phoneError.value = 'Mobile number is required';
      return;
    }

    if (!validatePhone()) return;

    try {
      isLoading.value = true;
      // final fullPhone = "${countryCode.value}${mobileController.text}";
      final fullPhone = mobileController.text;
      final ResModel res = await apiService.get(
        "${ApiConstants.searchUser}?phone=$fullPhone",
      );

      if (res.status == 200) {
        final userData = res.data;

        // Check if already in list
        if (familyMembers.any((m) => m.memberId == userData['_id'])) {
          AppSnackbar.error("Member already added");
          return;
        }

        familyMembers.add(
          FamilyMemberLocal(
            memberId: userData['_id']?.toString() ?? '',
            name: userData['name'] ?? '',
            phone: userData['phoneNumber'] ?? '',
            image: userData['image'] ?? '',
            relationship: relation.value,
          ),
        );

        // Reset and close
        mobileController.clear();
        relation.value = '';
        Get.back();
      }
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
    } finally {
      isLoading.value = false;
    }
  }

  void removeMember(int index) {
    if (index >= 0 && index < familyMembers.length) {
      familyMembers.removeAt(index);
    }
  }

  void saveFamily() async {
    if (familyMembers.isEmpty) {
      AppSnackbar.error("Please add at least one family member");
      return;
    }

    try {
      isLoading.value = true;
      final List membersPayload = familyMembers.map((m) => m.toJson()).toList();

      final body = {
        "userId": storageService.user.id,
        "members": membersPayload,
      };

      ResModel res;
      if (familyId?.value == null || familyId!.value.isEmpty) {
        res = await apiService.post(ApiConstants.addFamily, body: body);
      } else {
        res = await apiService.put(
          ApiConstants.updateFamily,
          body: {"familyId": familyId?.value, ...body},
        );
      }

      if (res.status == 200 || res.status == 201) {
        AppSnackbar.success("Family updated successfully!");
        getFamily(); // Refresh to ensure we have latest data/IDs
      }
    } catch (e) {
      AppSnackbar.error("Error saving family: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
