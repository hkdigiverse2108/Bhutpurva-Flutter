import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/constants/app_size.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/modules/member/controllers/member_update_controller.dart';
import 'package:gurukul_bhutpurva/shared/widgets/form_fields/common_text_form_field.dart';

class MemberMajorDetails extends GetView<MemberUpdateController> {
  const MemberMajorDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: controller.majorDetailsFormKey,
        child: Column(
          children: [
            CommonTextFormField(
              label: 'Your HR No',
              readOnly: true,
              controller: controller.hrNoController,
            ),
            const Gap(12),
            CommonTextFormField(
              label: 'Your Current City',
              isRequired: true,
              fieldType: FieldType.dropdown,
              dropdownItems: controller.currentCityList,
              dropdownValue: controller.currentCity.value,
              onDropdownChanged: (value) {
                controller.currentCity.value = value!;
              },
            ),
            const Gap(12),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                "Class 10 Details",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.fontSizeMd,
                ),
              ),
            ),
            Divider(thickness: 2),
            const Gap(12),
            CommonTextFormField(
              label: 'Class 10 Studied in gurukul ?',
              isRequired: true,
              fieldType: FieldType.dropdown,
              dropdownItems: ClassStatus.values.map((e) => e.name).toList(),
              dropdownValue: controller.tenTh.value.isInGurukul.value.name,
              onDropdownChanged: (value) {
                controller.tenTh.value.isInGurukul.value = ClassStatus.values
                    .firstWhere((e) => e.name == value!);
              },
            ),
            Obx(
              () => controller.tenTh.value.isInGurukul.value == ClassStatus.yes
                  ? const Gap(12)
                  : SizedBox.shrink(),
            ),
            Obx(
              () => controller.tenTh.value.isInGurukul.value == ClassStatus.yes
                  ? Row(
                      children: [
                        /// -------- Branch Dropdown --------
                        Expanded(
                          flex: 4,
                          child: CommonTextFormField(
                            label: "Your Branch",
                            isRequired: true,
                            hintText: 'select',
                            fieldType: FieldType.dropdown,
                            dropdownItems: controller.branch
                                .map((e) => e.name)
                                .toList(),
                            dropdownValue: controller.tenTh.value.branch.value,
                            onDropdownChanged: (value) {
                              controller.tenTh.value.branch.value = value!;
                            },
                          ),
                        ),

                        const Gap(12),

                        /// -------- Passing Year Dropdown --------
                        Expanded(
                          flex: 3,
                          child: CommonTextFormField(
                            label: "Passing Year",
                            isRequired: true,
                            hintText: 'select',
                            fieldType: FieldType.dropdown,
                            dropdownItems: controller.passingYears,
                            dropdownValue:
                                controller
                                    .tenTh
                                    .value
                                    .passingYear
                                    .value!
                                    .isEmpty
                                ? null
                                : controller.tenTh.value.passingYear.value,
                            onDropdownChanged: (value) {
                              controller.tenTh.value.passingYear.value = value!;
                            },
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            Obx(
              () => controller.tenTh.value.isInGurukul.value == ClassStatus.yes
                  ? const Gap(12)
                  : SizedBox.shrink(),
            ),
            Obx(
              () => controller.tenTh.value.isInGurukul.value == ClassStatus.yes
                  ? Row(
                      children: [
                        /// -------- Branch Dropdown --------
                        Expanded(
                          flex: 1,
                          child: CommonTextFormField(
                            label: "Medium",
                            isRequired: true,
                            hintText: 'select',
                            fieldType: FieldType.dropdown,
                            dropdownItems: const ['English', 'Gujarati'],
                            dropdownValue: controller.tenTh.value.medium.value,
                            onDropdownChanged: (value) {
                              controller.tenTh.value.medium.value = value!;
                            },
                          ),
                        ),

                        const Gap(12),

                        /// -------- Passing Year Dropdown --------
                        Expanded(
                          flex: 1,
                          child: CommonTextFormField(
                            label: "Hostel",
                            isRequired: false,
                            fieldType: FieldType.dropdown,
                            hintText: 'select',
                            dropdownItems: controller.hostels,
                            dropdownValue:
                                controller.tenTh.value.hostel.value!.isEmpty
                                ? null
                                : controller.tenTh.value.hostel.value,
                            onDropdownChanged: (value) {
                              controller.tenTh.value.hostel.value = value!;
                            },
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            const Gap(12),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                "Class 12 Details",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.fontSizeMd,
                ),
              ),
            ),
            Divider(thickness: 2),
            const Gap(12),
            CommonTextFormField(
              label: 'Class 12 Studied in gurukul ?',
              isRequired: true,
              fieldType: FieldType.dropdown,
              dropdownItems: ClassStatus.values.map((e) => e.name).toList(),
              dropdownValue: controller.twelveTh.value.isInGurukul.value.name,
              onDropdownChanged: (value) {
                controller.twelveTh.value.isInGurukul.value = ClassStatus.values
                    .firstWhere((e) => e.name == value!);
              },
            ),
            Obx(
              () =>
                  controller.twelveTh.value.isInGurukul.value == ClassStatus.yes
                  ? const Gap(12)
                  : SizedBox.shrink(),
            ),
            Obx(
              () =>
                  controller.twelveTh.value.isInGurukul.value == ClassStatus.yes
                  ? Row(
                      children: [
                        /// -------- Branch Dropdown --------
                        Expanded(
                          flex: 4,
                          child: CommonTextFormField(
                            label: "Your Branch",
                            isRequired: true,
                            hintText: 'select',
                            fieldType: FieldType.dropdown,
                            dropdownItems: controller.branch
                                .map((e) => e.name)
                                .toList(),
                            dropdownValue:
                                controller.twelveTh.value.branch.value,
                            onDropdownChanged: (value) {
                              controller.twelveTh.value.branch.value = value!;
                            },
                          ),
                        ),

                        const Gap(12),

                        /// -------- Passing Year Dropdown --------
                        Expanded(
                          flex: 3,
                          child: CommonTextFormField(
                            label: "Passing Year",
                            isRequired: true,
                            hintText: 'select',
                            fieldType: FieldType.dropdown,
                            dropdownItems: controller.passingYears,
                            dropdownValue:
                                controller
                                    .twelveTh
                                    .value
                                    .passingYear
                                    .value!
                                    .isEmpty
                                ? null
                                : controller.twelveTh.value.passingYear.value,
                            onDropdownChanged: (value) {
                              controller.twelveTh.value.passingYear.value =
                                  value!;
                            },
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            Obx(
              () =>
                  controller.twelveTh.value.isInGurukul.value == ClassStatus.yes
                  ? const Gap(12)
                  : SizedBox.shrink(),
            ),
            Obx(
              () =>
                  controller.twelveTh.value.isInGurukul.value == ClassStatus.yes
                  ? Row(
                      children: [
                        /// -------- Branch Dropdown --------
                        Expanded(
                          flex: 1,
                          child: CommonTextFormField(
                            label: "Medium",
                            isRequired: true,
                            hintText: 'select',
                            fieldType: FieldType.dropdown,
                            dropdownItems: const ['English', 'Gujarati'],
                            dropdownValue:
                                controller.twelveTh.value.medium.value,
                            onDropdownChanged: (value) {
                              controller.twelveTh.value.medium.value = value!;
                            },
                          ),
                        ),

                        const Gap(12),

                        /// -------- Passing Year Dropdown --------
                        Expanded(
                          flex: 1,
                          child: CommonTextFormField(
                            label: "Hostel",
                            isRequired: false,
                            fieldType: FieldType.dropdown,
                            hintText: 'select',
                            dropdownItems: controller.hostels,
                            dropdownValue:
                                controller.twelveTh.value.hostel.value!.isEmpty
                                ? null
                                : controller.twelveTh.value.hostel.value,
                            onDropdownChanged: (value) {
                              controller.twelveTh.value.hostel.value = value!;
                            },
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
