import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/data/models/class/class_model.dart';
import 'package:gurukul_bhutpurva/modules/member/controllers/member_update_controller.dart';
import 'package:gurukul_bhutpurva/shared/widgets/form_fields/common_text_form_field.dart';

class MemberClassWiseStudyDetails extends GetView<MemberUpdateController> {
  const MemberClassWiseStudyDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: controller.classDetailsFormKey,
        child: Column(
          children: [
            // ===================== CLASS 1 =====================
            _classSection(context, classNo: 1, model: controller.class1),

            // ===================== CLASS 2 =====================
            _classSection(context, classNo: 2, model: controller.class2),

            // ===================== CLASS 3 =====================
            _classSection(context, classNo: 3, model: controller.class3),

            // ===================== CLASS 4 =====================
            _classSection(context, classNo: 4, model: controller.class4),

            // ===================== CLASS 5 =====================
            _classSection(context, classNo: 5, model: controller.class5),

            // ===================== CLASS 6 =====================
            _classSection(context, classNo: 6, model: controller.class6),

            // ===================== CLASS 7 =====================
            _classSection(context, classNo: 7, model: controller.class7),

            // ===================== CLASS 8 =====================
            _classSection(context, classNo: 8, model: controller.class8),

            // ===================== CLASS 9 =====================
            _classSection(context, classNo: 9, model: controller.class9),

            // ===================== CLASS 10 =====================
            _classSection(context, classNo: 10, model: controller.class10),

            // ===================== CLASS 11 =====================
            _classSection(context, classNo: 11, model: controller.class11),

            // ===================== CLASS 12 =====================
            _classSection(context, classNo: 12, model: controller.class12),
          ],
        ),
      ),
    );
  }

  Widget _classSection(
    BuildContext context, {
    required int classNo,
    required Rx<ClassModel> model,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Have You Studied class $classNo in Gurukul?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const Gap(12),
        Obx(
          () => Row(
            children: [
              Expanded(
                flex: 3,
                child: CommonTextFormField(
                  fieldType: FieldType.dropdown,
                  dropdownItems: ClassStatus.values.map((e) => e.name).toList(),
                  dropdownValue: model.value.isInGurukul.value.name,
                  onDropdownChanged: (value) {
                    model.value.isInGurukul.value = ClassStatus.values
                        .firstWhere((e) => e.name == value!);
                  },
                ),
              ),
              const Gap(12),
              Expanded(
                flex: 4,
                child: model.value.isInGurukul.value == ClassStatus.yes
                    ? CommonTextFormField(
                        hintText: 'select',
                        fieldType: FieldType.dropdown,
                        dropdownItems: controller.branch
                            .map((e) => e.name)
                            .toList(),
                        dropdownValue: model.value.branch.value,
                        onDropdownChanged: (value) {
                          model.value.branch.value = value!;
                        },
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        const Gap(24),
      ],
    );
  }
}
