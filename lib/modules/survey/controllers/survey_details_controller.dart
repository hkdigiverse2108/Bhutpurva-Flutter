import 'dart:developer';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:gurukul_bhutpurva/data/models/survey/survey_model.dart';
import 'package:gurukul_bhutpurva/modules/survey/controllers/survey_controller.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';

class SurveyDetailsController extends GetxController {
  final apiService = ApiService.to;
  late SurveyModel survey;

  final RxMap<String, dynamic> answers = <String, dynamic>{}.obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is SurveyModel) {
      survey = Get.arguments;
      _initializeEmptyAnswers();
    } else {
      AppSnackbar.error("Invalid survey data");
      Get.back();
    }
  }

  void _initializeEmptyAnswers() {
    for (var question in survey.questions) {
      if (question.questionType == 'multiple_choice') {
        answers[question.id] = <String>[];
      } else if (question.questionType == 'boolean') {
        answers[question.id] = null; // To handle unselected state
      } else if (question.questionType == 'rating') {
        answers[question.id] = 0;
      } else {
        answers[question.id] = "";
      }
    }
  }

  void updateAnswer(String questionId, dynamic value) {
    answers[questionId] = value;
  }

  bool isQuestionAnswered(Question question) {
    var ans = answers[question.id];
    if (question.questionType == 'multiple_choice') {
      return (ans as List).isNotEmpty;
    }
    if (question.questionType == 'boolean' ||
        question.questionType == 'rating') {
      return ans != null && ans != 0;
    }
    return ans != null && ans.toString().isNotEmpty;
  }

  bool get canSubmit {
    for (var question in survey.questions) {
      if (question.isRequired && !isQuestionAnswered(question)) {
        return false;
      }
    }
    return true;
  }

  Future<void> submitSurvey() async {
    if (!canSubmit) {
      AppSnackbar.error("Please answer all required questions");
      return;
    }

    try {
      isSubmitting.value = true;

      final List<Map<String, dynamic>> answerList = [];
      answers.forEach((id, val) {
        // Only include non-null/non-empty answers or all required ones
        if (val != null) {
          answerList.add({"questionId": id, "answer": val});
        }
      });

      final Map<String, dynamic> payload = {
        "surveyId": survey.id,
        "answers": answerList,
      };

      final ResModel res = await apiService.post(
        ApiConstants.submitSurvey,
        body: payload,
      );

      if (res.status == 200 || res.status == 201) {
        // Update local state in the list controller
        final listController = Get.find<SurveyController>();
        final index = listController.surveys.indexWhere(
          (s) => s.id == survey.id,
        );
        if (index != -1) {
          final updatedSurvey = SurveyModel(
            id: survey.id,
            title: survey.title,
            description: survey.description,
            scope: survey.scope,
            questions: survey.questions,
            isActive: survey.isActive,
            isDeleted: survey.isDeleted,
            createdBy: survey.createdBy,
            createdAt: survey.createdAt,
            updatedAt: DateTime.now(),
            isCompleted: true,
          );
          listController.surveys[index] = updatedSurvey;
        }

        Get.back();
        AppSnackbar.success("Survey submitted successfully");
      } else {
        AppSnackbar.error(res.message ?? "Submission failed");
      }
    } catch (e) {
      log("Survey Submission Error: $e");
      AppSnackbar.error("Something went wrong during submission");
    } finally {
      isSubmitting.value = false;
    }
  }
}
