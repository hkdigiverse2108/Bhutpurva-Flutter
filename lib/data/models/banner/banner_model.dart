import 'dart:convert';

class BannerModel {
  String id;
  String image;
  String title;
  String subtitle;
  String link;
  bool isActive;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;

  BannerModel({
    required this.id,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.link,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BannerModel.fromRawJson(String str) =>
      BannerModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic date) {
      if (date == null) return null;
      return DateTime.tryParse(date.toString());
    }

    return BannerModel(
      id: json["_id"] ?? '',
      image: json["image"] ?? '',
      title: json["title"] ?? '',
      subtitle: json["subtitle"] ?? '',
      link: json["link"] ?? '',
      isActive: json["isActive"] ?? false,
      isDeleted: json["isDeleted"] ?? false,
      createdAt: parseDate(json["createdAt"]) ?? DateTime.now(),
      updatedAt: parseDate(json["updatedAt"]) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "image": image,
    "title": title,
    "subtitle": subtitle,
    "link": link,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
