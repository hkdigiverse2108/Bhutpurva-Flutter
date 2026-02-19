import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/core/services/validation_service.dart';
import 'package:gurukul_bhutpurva/modules/auth/controllers/register_controller.dart';
import 'package:gurukul_bhutpurva/shared/widgets/form_fields/common_text_form_field.dart';

class AddressDetails extends GetView<RegisterController> {
  const AddressDetails({super.key});

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
            Text(
              "Current Address (હાલનું સરનામું)",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
            Divider(thickness: 2),
            const Gap(12),

            CommonTextFormField(
              label: 'Full Address (સંપૂર્ણ સરનામું)',
              isRequired: true,
              validator: ValidationService.isEmpty,
              initialValue: controller.currentAddress.value.fullAddress,
              onChanged: (v) => controller.currentAddress.value = controller
                  .currentAddress
                  .value
                  .copyWith(fullAddress: v),
            ),
            const Gap(12),

            Row(
              children: [
                Expanded(
                  child: CommonTextFormField(
                    label: 'City (શહેર)',
                    initialValue: controller.currentAddress.value.city,
                    onChanged: (v) => controller.currentAddress.value =
                        controller.currentAddress.value.copyWith(city: v),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: CommonTextFormField(
                    label: 'District (જિલ્લો)',
                    initialValue: controller.currentAddress.value.district,
                    onChanged: (v) => controller.currentAddress.value =
                        controller.currentAddress.value.copyWith(district: v),
                  ),
                ),
              ],
            ),

            const Gap(12),

            CommonTextFormField(
              fieldType: FieldType.dropdown,
              label: 'Country (દેશ)',
              dropdownItems: controller.countries,
              dropdownValue: controller.currentAddress.value.country,
              onDropdownChanged: (v) => controller.currentAddress.value =
                  controller.currentAddress.value.copyWith(country: v!),
            ),
            const Gap(12),

            Row(
              children: [
                Expanded(
                  child: CommonTextFormField(
                    fieldType: FieldType.dropdown,
                    label: 'State (રાજ્ય)',
                    dropdownItems: controller.states,
                    dropdownValue: controller.currentAddress.value.state,
                    onDropdownChanged: (v) => controller.currentAddress.value =
                        controller.currentAddress.value.copyWith(state: v!),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: CommonTextFormField(
                    label: 'Pincode (પિનકોડ)',
                    keyboardType: TextInputType.number,
                    initialValue: controller.currentAddress.value.pincode,
                    onChanged: (v) => controller.currentAddress.value =
                        controller.currentAddress.value.copyWith(pincode: v),
                  ),
                ),
              ],
            ),

            const Gap(32),

            /// ================= VILLAGE ADDRESS =================
            Text(
              "Village Address (ગામનું સરનામું)",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
            Divider(thickness: 2),
            const Gap(12),

            CommonTextFormField(
              label: 'Full Address (સંપૂર્ણ સરનામું)',
              initialValue: controller.villageAddress.value.fullAddress,
              onChanged: (v) => controller.villageAddress.value = controller
                  .villageAddress
                  .value
                  .copyWith(fullAddress: v),
            ),
            const Gap(12),

            Row(
              children: [
                Expanded(
                  child: CommonTextFormField(
                    label: 'City (શહેર)',
                    initialValue: controller.villageAddress.value.city,
                    onChanged: (v) => controller.villageAddress.value =
                        controller.villageAddress.value.copyWith(city: v),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: CommonTextFormField(
                    label: 'District (જિલ્લો)',
                    initialValue: controller.villageAddress.value.district,
                    onChanged: (v) => controller.villageAddress.value =
                        controller.villageAddress.value.copyWith(district: v),
                  ),
                ),
              ],
            ),
            const Gap(12),

            CommonTextFormField(
              fieldType: FieldType.dropdown,
              label: 'Country (દેશ)',
              dropdownItems: controller.countries,
              dropdownValue: controller.villageAddress.value.country,
              onDropdownChanged: (v) => controller.villageAddress.value =
                  controller.villageAddress.value.copyWith(country: v!),
            ),
            const Gap(12),

            Row(
              children: [
                Expanded(
                  child: CommonTextFormField(
                    fieldType: FieldType.dropdown,
                    label: 'State (રાજ્ય)',
                    dropdownItems: controller.states,
                    dropdownValue: controller.villageAddress.value.state,
                    onDropdownChanged: (v) => controller.villageAddress.value =
                        controller.villageAddress.value.copyWith(state: v!),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: CommonTextFormField(
                    label: 'Pincode (પિનકોડ)',
                    keyboardType: TextInputType.number,
                    initialValue: controller.villageAddress.value.pincode,
                    onChanged: (v) => controller.villageAddress.value =
                        controller.villageAddress.value.copyWith(pincode: v),
                  ),
                ),
              ],
            ),
            const Gap(32),

            Text(
              "Additional Address (વધારાનું સરનામું)",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
            Divider(thickness: 2),
            const Gap(12),

            /// ADDRESS LIST
            Obx(
              () => Column(
                children: List.generate(controller.otherAddressList.length, (
                  index,
                ) {
                  final address = controller.otherAddressList[index];

                  return Card(
                    elevation: 3,
                    color: AppColors.lightGrey,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// HEADER
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Address ${index + 1}",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    controller.removeOtherAddress(index),
                              ),
                            ],
                          ),
                          const Gap(12),

                          /// ADDRESS TYPE
                          CommonTextFormField(
                            fieldType: FieldType.dropdown,
                            label: 'Address Type',
                            hintText: 'Select',
                            dropdownItems: controller.addressType,
                            dropdownValue: address.value.addressType,
                            onDropdownChanged: (v) {
                              address.value = address.value.copyWith(
                                addressType: v!,
                              );
                            },
                          ),
                          const Gap(12),

                          /// FULL ADDRESS
                          CommonTextFormField(
                            label: 'Full Address',
                            initialValue: address.value.fullAddress,
                            onChanged: (v) => address.value = address.value
                                .copyWith(fullAddress: v),
                          ),
                          const Gap(12),

                          Row(
                            children: [
                              Expanded(
                                child: CommonTextFormField(
                                  label: 'City',
                                  initialValue: address.value.city,
                                  onChanged: (v) => address.value = address
                                      .value
                                      .copyWith(city: v),
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                child: CommonTextFormField(
                                  label: 'District',
                                  initialValue: address.value.district,
                                  onChanged: (v) => address.value = address
                                      .value
                                      .copyWith(district: v),
                                ),
                              ),
                            ],
                          ),
                          const Gap(12),

                          CommonTextFormField(
                            fieldType: FieldType.dropdown,
                            label: 'Country',
                            dropdownItems: controller.countries,
                            dropdownValue: address.value.country,
                            onDropdownChanged: (v) => address.value = address
                                .value
                                .copyWith(country: v!),
                          ),
                          const Gap(12),

                          Row(
                            children: [
                              Expanded(
                                child: CommonTextFormField(
                                  fieldType: FieldType.dropdown,
                                  label: 'State',
                                  dropdownItems: controller.states,
                                  dropdownValue: address.value.state,
                                  onDropdownChanged: (v) => address.value =
                                      address.value.copyWith(state: v!),
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                child: CommonTextFormField(
                                  label: 'Pincode',
                                  keyboardType: TextInputType.number,
                                  initialValue: address.value.pincode,
                                  onChanged: (v) => address.value = address
                                      .value
                                      .copyWith(pincode: v),
                                ),
                              ),
                            ],
                          ),
                          const Gap(10),
                        ],
                      ),
                    ),
                  );
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
