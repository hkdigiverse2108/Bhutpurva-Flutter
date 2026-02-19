import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/core/services/validation_service.dart';
import 'package:gurukul_bhutpurva/modules/auth/controllers/register_controller.dart';
import 'package:gurukul_bhutpurva/shared/widgets/form_fields/common_text_form_field.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PrimaryDetails extends GetView<RegisterController> {
  const PrimaryDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(16),
      child: Form(
        key: controller.primaryDetailsFormKey,
        child: Column(
          children: [
            CommonTextFormField(
              label: 'Name (નામ)',
              hintText: 'Enter Name',
              isRequired: true,
              controller: controller.nameController,
              validator: (value) =>
                  ValidationService.isEmpty(value, name: 'Name'),
            ),
            const Gap(12),
            CommonTextFormField(
              label: 'Father Name (પિતાનું નામ)',
              hintText: 'Enter Father Name',
              isRequired: true,
              controller: controller.fatherNameController,
              validator: (value) =>
                  ValidationService.isEmpty(value, name: 'Father Name'),
            ),
            const Gap(12),
            CommonTextFormField(
              label: 'Surname (અટક)',
              hintText: 'Enter Surname',
              isRequired: true,
              controller: controller.surnameController,
              validator: (value) =>
                  ValidationService.isEmpty(value, name: 'Surname'),
            ),
            const Gap(12),
            CommonTextFormField(
              label: 'Birth Date (જન્મ તારીખ)',
              hintText: 'Select Date',
              isRequired: true,
              readOnly: true,
              suffixIcon: GestureDetector(
                onTap: () async {
                  final date = await controller.selectDate();
                  if (date == null) {}
                },
                child: Icon(PhosphorIconsBold.calendarDots),
              ),
              controller: controller.birthDateController,
              validator: (value) =>
                  ValidationService.isEmpty(value, name: 'Birth Date'),
            ),
            const Gap(12),
            CommonTextFormField(
              label: 'Phone Number (ફોન નંબર)',
              isRequired: true,
              controller: controller.phoneController,
              hintText: 'Enter Phone Number',
              validator: (value) => ValidationService.validatePhone(value),
            ),
            Obx(
              () => CheckboxListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  "Is Whatsapp Number",
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                subtitle: Text(
                  "(ફોન નંબર અને વાટસએપ નંબર એક નંબર છે)",
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                value: controller.isWhatsappNumber.value,
                onChanged: (value) {
                  controller.isWhatsappNumber.toggle();
                },
              ),
            ),
            Obx(
              () => (!controller.isWhatsappNumber.value)
                  ? CommonTextFormField(
                      label: 'WhatsApp Number (વાટસએપ નંબર)',
                      controller: controller.phoneController,
                      hintText: 'Enter WhatsApp Number',
                    )
                  : SizedBox.shrink(),
            ),
            Obx(
              () => (!controller.isWhatsappNumber.value)
                  ? const Gap(12)
                  : SizedBox.shrink(),
            ),
            CommonTextFormField(
              label: "Gender (જાતિ)",
              fieldType: FieldType.dropdown,
              isRequired: true,
              dropdownItems: ["Male", "Female", "Other"],
              dropdownValue: controller.gender.value,
              onDropdownChanged: (value) {
                controller.gender.value = value!;
              },
              validator: (value) =>
                  ValidationService.isEmpty(value, name: 'Gender'),
            ),
            const Gap(12),
            CommonTextFormField(
              label: 'Email (ઈમેલ)',
              hintText: 'Enter Email',
              isRequired: true,
              controller: controller.emailController,
              validator: (value) => ValidationService.validateEmail(value),
            ),
          ],
        ),
      ),
    );
  }
}
