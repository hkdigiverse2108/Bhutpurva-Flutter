import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/constants/app_size.dart';
import 'package:gurukul_bhutpurva/data/models/survey/survey_model.dart';
import 'package:gurukul_bhutpurva/modules/survey/controllers/survey_details_controller.dart';
import 'package:gurukul_bhutpurva/shared/widgets/form_fields/common_text_form_field.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SurveyDetailsView extends GetView<SurveyDetailsController> {
  const SurveyDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Get.arguments == null) {
      return const Scaffold(body: Center(child: Text("Invalid Survey Data")));
    }

    // Inject controller if not already present (sometimes needed with GetView)
    if (!Get.isRegistered<SurveyDetailsController>()) {
      Get.put(SurveyDetailsController());
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(title: Text(controller.survey.title), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSize.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppSize.spaceBtwSections),
            ...controller.survey.questions.map((q) => _buildQuestion(q)),
            const SizedBox(height: AppSize.spaceBtwSections),
            _buildSubmitButton(),
            const SizedBox(height: AppSize.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSize.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.cardRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.survey.title,
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSize.sm),
          Text(
            controller.survey.description,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(Question question) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSize.spaceBtwItems),
      padding: const EdgeInsets.all(AppSize.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.cardRadiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  question.questionText,
                  style: Get.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (question.isRequired)
                const Text(
                  " *",
                  style: TextStyle(color: AppColors.error, fontSize: 16),
                ),
            ],
          ),
          const SizedBox(height: AppSize.md),
          _buildQuestionInput(question),
        ],
      ),
    );
  }

  Widget _buildQuestionInput(Question question) {
    switch (question.questionType) {
      case 'text':
        return CommonTextFormField(
          hintText: "Type your answer here...",
          maxLines: 3,
          onChanged: (val) => controller.updateAnswer(question.id, val),
        );
      case 'rating':
        return _RatingInput(
          onChanged: (val) => controller.updateAnswer(question.id, val),
        );
      case 'boolean':
        return _ChoiceInput(
          question: question,
          options: const ["Yes", "No"],
          isBoolean: true,
          onChanged: (val) =>
              controller.updateAnswer(question.id, val == "Yes"),
        );
      case 'single_choice':
        return _ChoiceInput(
          question: question,
          options: question.options,
          onChanged: (val) => controller.updateAnswer(question.id, val),
        );
      case 'multiple_choice':
        return _MultipleChoiceInput(
          question: question,
          onChanged: (vals) => controller.updateAnswer(question.id, vals),
        );
      default:
        return Text("Unknown Type: ${question.questionType}");
    }
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      final isEnabled = controller.canSubmit;
      final isSubmitting = controller.isSubmitting.value;

      return SizedBox(
        width: double.infinity,
        height: AppSize.buttonHeight,
        child: ElevatedButton(
          onPressed: (isEnabled && !isSubmitting)
              ? controller.submitSurvey
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.buttonRadius),
            ),
            elevation: isEnabled ? 4 : 0,
          ),
          child: isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "Submit Survey",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
      );
    });
  }
}

class _RatingInput extends StatefulWidget {
  final ValueChanged<int> onChanged;
  const _RatingInput({required this.onChanged});

  @override
  State<_RatingInput> createState() => _RatingInputState();
}

class _RatingInputState extends State<_RatingInput> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        return IconButton(
          icon: Icon(
            starValue <= rating
                ? PhosphorIconsFill.star
                : PhosphorIconsRegular.star,
            color: starValue <= rating ? AppColors.primary : AppColors.grey,
            size: 32,
          ),
          onPressed: () {
            setState(() => rating = starValue);
            widget.onChanged(starValue);
          },
        );
      }),
    );
  }
}

class _ChoiceInput extends StatefulWidget {
  final Question question;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final bool isBoolean;

  const _ChoiceInput({
    required this.question,
    required this.options,
    required this.onChanged,
    this.isBoolean = false,
  });

  @override
  State<_ChoiceInput> createState() => _ChoiceInputState();
}

class _ChoiceInputState extends State<_ChoiceInput> {
  String? selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.options.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: selected,
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
          onChanged: (val) {
            setState(() => selected = val);
            if (val != null) widget.onChanged(val);
          },
        );
      }).toList(),
    );
  }
}

class _MultipleChoiceInput extends StatefulWidget {
  final Question question;
  final ValueChanged<List<String>> onChanged;

  const _MultipleChoiceInput({required this.question, required this.onChanged});

  @override
  State<_MultipleChoiceInput> createState() => _MultipleChoiceInputState();
}

class _MultipleChoiceInputState extends State<_MultipleChoiceInput> {
  final List<String> selected = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.question.options.map((option) {
        return CheckboxListTile(
          title: Text(option),
          value: selected.contains(option),
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
          onChanged: (val) {
            setState(() {
              if (val == true) {
                selected.add(option);
              } else {
                selected.remove(option);
              }
            });
            widget.onChanged(selected);
          },
        );
      }).toList(),
    );
  }
}
