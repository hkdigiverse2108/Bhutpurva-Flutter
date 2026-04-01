import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/data/models/address/location_model.dart';
import 'package:gurukul_bhutpurva/modules/profile/controllers/update_profile_controller.dart';
import 'package:gurukul_bhutpurva/shared/widgets/form_fields/common_text_form_field.dart';
import 'package:gurukul_bhutpurva/shared/widgets/location_picker_form.dart';

class UpdateAddressDetails extends GetView<UpdateProfileController> {
  const UpdateAddressDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: controller.addressDetailsFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= CURRENT ADDRESS =================
            Obx(() => AddressFormWidget(
                  index: 0,
                  address: controller.currentAddress.value,
                  title: "Current Address (હાલનું સરનામું)",
                  onAddressChanged: (v) => controller.currentAddress.value =
                      controller.currentAddress.value.copyWith(fullAddress: v),
                  onPincodeChanged: (v) => controller.currentAddress.value =
                      controller.currentAddress.value.copyWith(pincode: v),
                  onCountryChanged: (id, name) => controller.onCountryChanged(
                      controller.currentAddress, id, name),
                  onStateChanged: (id, name) => controller.onStateChanged(
                      controller.currentAddress, id, name),
                  onDistrictChanged: (id, name) => controller.onDistrictChanged(
                      controller.currentAddress, id, name),
                  onCityChanged: (id, name) => controller.onCityChanged(
                      controller.currentAddress, id, name),
                )),
            const Gap(16),

            /// ================= VILLAGE ADDRESS =================
            Obx(() => AddressFormWidget(
                  index: 1,
                  address: controller.villageAddress.value,
                  title: "Village Address (ગામનું સરનામું)",
                  onAddressChanged: (v) => controller.villageAddress.value =
                      controller.villageAddress.value.copyWith(fullAddress: v),
                  onPincodeChanged: (v) => controller.villageAddress.value =
                      controller.villageAddress.value.copyWith(pincode: v),
                  onCountryChanged: (id, name) => controller.onCountryChanged(
                      controller.villageAddress, id, name),
                  onStateChanged: (id, name) => controller.onStateChanged(
                      controller.villageAddress, id, name),
                  onDistrictChanged: (id, name) => controller.onDistrictChanged(
                      controller.villageAddress, id, name),
                  onCityChanged: (id, name) => controller.onCityChanged(
                      controller.villageAddress, id, name),
                )),
            const Gap(16),

            Text(
              "Additional Address (વધારાનું સરનામું)",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
            ),
            const Divider(thickness: 2),
            const Gap(12),

            /// ADDRESS LIST
            Obx(
              () => Column(
                children: List.generate(controller.otherAddressList.length, (
                  index,
                ) {
                  final addressMap = controller.otherAddressList[index];
                  final selectedType = addressMap['selectedType'] as RxString;
                  final addressEntry = addressMap['address'] as Rx<AddressEntry>;

                  return Obx(() => AddressFormWidget(
                        index: index,
                        address: addressEntry.value,
                        title: "Address ${index + 1}",
                        onRemove: () => controller.removeOtherAddress(index),
                        topWidget: CommonTextFormField(
                          fieldType: FieldType.dropdown,
                          label: 'Address Type',
                          hintText: 'Select',
                          dropdownItems: controller.addressType,
                          dropdownValue: selectedType.value,
                          onDropdownChanged: (v) {
                            selectedType.value = v!;
                          },
                        ),
                        onAddressChanged: (v) => addressEntry.value =
                            addressEntry.value.copyWith(fullAddress: v),
                        onPincodeChanged: (v) => addressEntry.value =
                            addressEntry.value.copyWith(pincode: v),
                        onCountryChanged: (id, name) => controller.onCountryChanged(
                            addressEntry, id, name),
                        onStateChanged: (id, name) => controller.onStateChanged(
                            addressEntry, id, name),
                        onDistrictChanged: (id, name) => controller.onDistrictChanged(
                            addressEntry, id, name),
                        onCityChanged: (id, name) => controller.onCityChanged(
                            addressEntry, id, name),
                      ));
                }),
              ),
            ),
            const Gap(12),

            /// ADD BUTTON
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: controller.addOtherAddress,
                icon: const Icon(Icons.add),
                label: const Text("Add Address"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
