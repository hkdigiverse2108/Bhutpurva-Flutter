import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/modules/profile/controllers/update_profile_controller.dart';
import 'package:gurukul_bhutpurva/shared/widgets/buttons/custom_checkbox.dart';
import 'package:gurukul_bhutpurva/shared/widgets/form_fields/common_text_form_field.dart';

class UpdateSkillAndHobbies extends GetView<UpdateProfileController> {
  const UpdateSkillAndHobbies({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: controller.skillAndHobbiesFormKey,
        child: Column(
          children: [
            CommonTextFormField(
              label: "Your Skill (આવડત)",
              controller: controller.yourSkill,
            ),
            const Gap(24),
            CommonTextFormField(
              label: "Your Hobbies (શોખ)",
              controller: controller.yourHobbies,
            ),
            const Gap(24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Talents (પ્રતિભા)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// TALENTS CHECKBOX GRID
            Obx(
              () => Wrap(
                spacing: 24,
                runSpacing: 8,
                children: controller.talents.map((talent) {
                  return SizedBox(
                    width: (MediaQuery.of(context).size.width - 56) / 2,
                    child: InkWell(
                      onTap: () => controller.toggleTalent(talent),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomCheckbox(
                            isChecked: controller.selectedTalents.contains(
                              talent,
                            ),
                            onChange: (_) => controller.toggleTalent(talent),
                            size: 20,
                            iconSize: 16,
                            backgroundColor: AppColors.primary,
                          ),
                          const Gap(10),
                          Expanded(
                            child: Text(
                              '$talent (${controller.talentTranslations[talent] ?? ''})',
                              softWrap: false,
                              // maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            /// INSTRUMENT SECTION (ONLY WHEN SELECTED)
            Obx(
              () => controller.selectedTalents.contains('Instrument')
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),

                        Text(
                          'Write the instruments you play',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.instrumentController,
                                decoration: InputDecoration(
                                  hintText: 'Instruments Names',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: controller.addInstrument,
                              child: const Text('Add'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        /// ADDED INSTRUMENTS
                        Obx(
                          () => Wrap(
                            spacing: 8,
                            children: controller.instruments
                                .map(
                                  (i) => Chip(
                                    label: Text(i),
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      size: 18,
                                    ),
                                    onDeleted: () =>
                                        controller.removeInstrument(i),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),

            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text(
                'Write the Awards you Got',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.yourAwards,
                    decoration: InputDecoration(
                      hintText: 'Awards',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: controller.addAwards,
                  child: const Text('Add'),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Obx(
              () => SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 8,
                  children: controller.awards
                      .map(
                        (i) => Chip(
                          label: Text(i),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () => controller.removeAwards(i),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
