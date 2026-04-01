import 'dart:convert';

class BranchModel {
  final String id;
  final String name;

  BranchModel({required this.id, required this.name});

  factory BranchModel.fromRawJson(String str) =>
      BranchModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BranchModel.fromJson(Map<String, dynamic> json) =>
      BranchModel(id: json["_id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"_id": id, "name": name};
}
