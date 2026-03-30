import 'dart:convert';

class GroupModel {
  final String id;
  final String name;
  final List<LeaderId> leaderIds;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Batch> batches;
  final int batchCount;

  GroupModel({
    required this.id,
    required this.name,
    required this.leaderIds,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.batches,
    required this.batchCount,
  });

  factory GroupModel.fromRawJson(String str) =>
      GroupModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    id: json["_id"],
    name: json["name"],
    leaderIds: List<LeaderId>.from(
      json["leaderIds"].map((x) => LeaderId.fromJson(x)),
    ),
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    batches: List<Batch>.from(json["batches"].map((x) => Batch.fromJson(x))),
    batchCount: json["batchCount"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "leaderIds": List<dynamic>.from(leaderIds.map((x) => x.toJson())),
    "isActive": isActive,
    "isDeleted": isDeleted,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "batches": List<dynamic>.from(batches.map((x) => x.toJson())),
    "batchCount": batchCount,
  };
}

class Batch {
  final String id;
  final String name;
  final bool isActive;
  final String groupId;

  Batch({
    required this.id,
    required this.name,
    required this.isActive,
    required this.groupId,
  });

  factory Batch.fromRawJson(String str) => Batch.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Batch.fromJson(Map<String, dynamic> json) => Batch(
    id: json["_id"],
    name: json["name"],
    isActive: json["isActive"],
    groupId: json["groupId"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "isActive": isActive,
    "groupId": groupId,
  };
}

class LeaderId {
  final String id;
  final String name;
  final String fatherName;
  final String surname;
  final String phoneNumber;
  final String whatsappNumber;

  LeaderId({
    required this.id,
    required this.name,
    required this.fatherName,
    required this.surname,
    required this.phoneNumber,
    required this.whatsappNumber,
  });

  factory LeaderId.fromRawJson(String str) =>
      LeaderId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LeaderId.fromJson(Map<String, dynamic> json) => LeaderId(
    id: json["_id"],
    name: json["name"],
    fatherName: json["fatherName"],
    surname: json["surname"],
    phoneNumber: json["phoneNumber"],
    whatsappNumber: json["whatsappNumber"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "fatherName": fatherName,
    "surname": surname,
    "phoneNumber": phoneNumber,
    "whatsappNumber": whatsappNumber,
  };
}

class GroupDropdownModel {
  final String id;
  final String name;
  final bool isActive;

  GroupDropdownModel({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory GroupDropdownModel.fromRawJson(String str) =>
      GroupDropdownModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GroupDropdownModel.fromJson(Map<String, dynamic> json) =>
      GroupDropdownModel(
        id: json["_id"],
        name: json["name"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "isActive": isActive,
  };
}
