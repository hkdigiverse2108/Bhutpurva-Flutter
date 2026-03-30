import 'dart:convert';

class SurveyModel {
  final String id;
  final String title;
  final String description;
  final String scope;
  final List<Question> questions;
  final bool isActive;
  final bool isDeleted;
  final CreatedBy createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool? isCompleted;

  SurveyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.scope,
    required this.questions,
    required this.isActive,
    required this.isDeleted,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.isCompleted,
  });

  factory SurveyModel.fromRawJson(String str) =>
      SurveyModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SurveyModel.fromJson(Map<String, dynamic> json) => SurveyModel(
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    scope: json["scope"],
    questions: List<Question>.from(
      json["questions"].map((x) => Question.fromJson(x)),
    ),
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    createdBy: CreatedBy.fromJson(json["createdBy"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    isCompleted: json["isCompleted"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "scope": scope,
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
    "isActive": isActive,
    "isDeleted": isDeleted,
    "createdBy": createdBy.toJson(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "isCompleted": isCompleted,
  };
}

class CreatedBy {
  final String id;
  final String email;
  final String name;

  CreatedBy({required this.id, required this.email, required this.name});

  factory CreatedBy.fromRawJson(String str) =>
      CreatedBy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreatedBy.fromJson(Map<String, dynamic> json) =>
      CreatedBy(id: json["_id"], email: json["email"], name: json["name"]);

  Map<String, dynamic> toJson() => {"_id": id, "email": email, "name": name};
}

class Question {
  final String questionText;
  final String questionType;
  final List<String> options;
  final bool isRequired;
  final String id;

  Question({
    required this.questionText,
    required this.questionType,
    required this.options,
    required this.isRequired,
    required this.id,
  });

  factory Question.fromRawJson(String str) =>
      Question.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    questionText: json["questionText"],
    questionType: json["questionType"],
    options: List<String>.from(json["options"].map((x) => x)),
    isRequired: json["isRequired"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "questionText": questionText,
    "questionType": questionType,
    "options": List<dynamic>.from(options.map((x) => x)),
    "isRequired": isRequired,
    "_id": id,
  };
}
