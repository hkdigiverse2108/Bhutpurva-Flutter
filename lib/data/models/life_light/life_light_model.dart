import 'dart:convert';

class LifeLightModel {
  String id;
  String userId;
  String lifeLight;
  String status;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;

  LifeLightModel({
    required this.id,
    required this.userId,
    required this.lifeLight,
    required this.status,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LifeLightModel.fromRawJson(String str) =>
      LifeLightModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LifeLightModel.fromJson(Map<String, dynamic> json) => LifeLightModel(
    id: json["_id"],
    userId: json["userId"],
    lifeLight: json["lifeLight"],
    status: json["status"],
    isDeleted: json["isDeleted"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "lifeLight": lifeLight,
    "status": status,
    "isDeleted": isDeleted,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
