import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/modules/auth/controllers/register_controller.dart';
import 'package:gurukul_bhutpurva/shared/dialogs/sheets/multi_select_bottom_sheet.dart';
import 'package:gurukul_bhutpurva/shared/widgets/form_fields/common_text_form_field.dart';

class SecondaryDetails extends GetView<RegisterController> {
  const SecondaryDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: controller.secondaryDetailsFormKey,
        child: Column(
          children: [
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "Occupation Information (વ્યવસાય માહિતી)",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => CheckboxListTile(
                value: controller.isStudent.value,
                onChanged: (value) {
                  controller.isStudent.value = value ?? false;
                },
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "I am a Student",
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: const Text(
                  "(હું વિદ્યાર્થી છું)",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            Obx(
              () => CheckboxListTile(
                value: controller.isBusiness.value,
                onChanged: (value) {
                  controller.isBusiness.value = value ?? false;
                },
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "I run a Business",
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: const Text(
                  "(હું વ્યવસાય કરું છું)",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            Obx(
              () => CheckboxListTile(
                value: controller.isEmployee.value,
                onChanged: (value) {
                  controller.isEmployee.value = value ?? false;
                },
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "I am an Employee",
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: const Text(
                  "(હું નોકરીયાત છું)",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            Obx(
              () => CheckboxListTile(
                value: controller.isSelfEmployee.value,
                onChanged: (value) {
                  controller.isSelfEmployee.value = value ?? false;
                },
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "I am Self Employed",
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: const Text(
                  "(હું સ્વરોજગારી છું)",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            Obx(
              () => CheckboxListTile(
                value: controller.isRetired.value,
                onChanged: (value) {
                  controller.isRetired.value = value ?? false;
                },
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "I am Retired",
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: const Text(
                  "(હું નિવૃત છું)",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            Divider(thickness: 2),
            const Gap(10),

            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "Your Profession (તમારો વ્યવસાય)",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),

            const Gap(8),

            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Obx(
                () => Text(
                  controller.selectedProfessions.isEmpty
                      ? "Selected Profession :"
                      : "Selected Profession : ${controller.selectedProfessions.join(', ')}",
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),

            const Gap(8),

            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: OutlinedButton(
                onPressed: () {
                  Get.bottomSheet(
                    MultiSelectBottomSheet(
                      title: "My Profession",
                      items: controller.allProfessions,
                      selectedItems: controller.selectedProfessions,
                      onItemToggle: controller.toggleProfession,
                      onRemoveItem: (v) => controller.removeProfession(v),
                    ),
                    isScrollControlled: true,
                  );
                },
                child: const Text("Select Your Profession"),
              ),
            ),

            const Gap(12),

            CommonTextFormField(
              controller: controller.otherProfession,
              label: "Other Profession",
            ),
            const Gap(10),
            Divider(thickness: 2),
            const Gap(10),

            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "Your Education (તમારું શિક્ષણ)",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),

            const Gap(8),

            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Obx(
                () => Text(
                  controller.selectedEducations.isEmpty
                      ? "Selected Educations :"
                      : "Selected Educations : ${controller.selectedEducations.join(', ')}",
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),

            const Gap(8),

            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: OutlinedButton(
                onPressed: () {
                  Get.bottomSheet(
                    MultiSelectBottomSheet(
                      title: "My Educations",
                      items: controller.allEducations,
                      selectedItems: controller.selectedEducations,
                      onItemToggle: controller.toggleEducation,
                      onRemoveItem: (v) => controller.removeEducation(v),
                    ),
                    isScrollControlled: true,
                  );
                },
                child: const Text("Select Your Education"),
              ),
            ),

            const Gap(12),

            CommonTextFormField(
              controller: controller.otherEducation,
              label: "Other Education",
            ),
            const Gap(10),
            Divider(thickness: 2),
            const Gap(10),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "Are you married?",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text('શું તમે પરિણીત છો?'),
            ),
            const Gap(6),
            Obx(
              () => CommonTextFormField(
                fieldType: FieldType.dropdown,
                isRequired: true,
                dropdownItems: controller.maritalStatusList,
                dropdownValue: controller.maritalStatus.value == 'Not Selected'
                    ? null
                    : controller.maritalStatus.value,
                onDropdownChanged: (value) {
                  controller.maritalStatus.value = value!;
                },
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value == 'Not Selected') {
                    return 'Please select your marital status';
                  }
                  return null;
                },
              ),
            ),
            const Gap(10),
            Divider(thickness: 2),
            const Gap(10),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "Blood Group?",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text('બ્લડ ગ્રુપ'),
            ),
            const Gap(6),
            Obx(
              () => CommonTextFormField(
                fieldType: FieldType.dropdown,
                isRequired: true,
                dropdownItems: controller.bloodGroupList,
                dropdownValue: controller.bloodGroup.value == 'Select'
                    ? null
                    : controller.bloodGroup.value,
                onDropdownChanged: (value) {
                  controller.bloodGroup.value = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty || value == 'Select') {
                    return 'Please select your blood group';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
