import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class FamilyController extends GetxController {
  final familyMembers = [].obs;
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
    'Spouse',
    'Son',
    'Daughter',
  ];

  void selectCountry(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        countryCode.value = '+${country.phoneCode}';
        isoCode.value = country.countryCode; // ✅ FIX
        countryFlag.value = country.flagEmoji;
        phoneError.value = ''; // clear previous error
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
            /// DRAG HANDLE
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

            /// TITLE
            const Text(
              'Add Family Member',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 20),

            /// RELATION DROPDOWN
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

            /// MOBILE INPUT
            Row(
              children: [
                /// COUNTRY CODE
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

                /// MOBILE FIELD
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

            /// SEARCH BUTTON
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

  void searchMember() {
    if (relation.value.isEmpty) {
      Get.snackbar('Error', 'Please select relation');
      return;
    }

    if (mobileController.text.isEmpty) {
      phoneError.value = 'Mobile number is required';
      return;
    }

    if (!validatePhone()) return;

    // ✅ SAFE TO CALL API HERE

    Get.back();
  }
}
