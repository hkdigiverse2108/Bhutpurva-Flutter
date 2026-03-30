import 'dart:convert';

class SettingsModel {
  String? id;
  String? address;
  String? appName;
  String? appStoreId;
  String? appStoreUrl;
  DateTime? createdAt;
  String? logo;
  String? playStoreId;
  String? playStoreUrl;
  String? sgsiPdf;
  String? lifeLightImage;
  String? anubhutiImage;
  SocialLinks? socialLinks;
  String? supportEmail;
  String? supportPhone;
  String? supportWhatsApp;
  DateTime? updatedAt;
  String? webSiteUrl;

  SettingsModel({
    this.id,
    this.address,
    this.appName,
    this.appStoreId,
    this.appStoreUrl,
    this.createdAt,
    this.logo,
    this.playStoreId,
    this.playStoreUrl,
    this.lifeLightImage,
    this.anubhutiImage,
    this.sgsiPdf,
    this.socialLinks,
    this.supportEmail,
    this.supportPhone,
    this.supportWhatsApp,
    this.updatedAt,
    this.webSiteUrl,
  });

  factory SettingsModel.fromRawJson(String str) =>
      SettingsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
    id: json["_id"],
    address: json["address"],
    appName: json["appName"],
    appStoreId: json["appStoreId"],
    appStoreUrl: json["appStoreUrl"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    logo: json["logo"],
    playStoreId: json["playStoreId"],
    playStoreUrl: json["playStoreUrl"],
    lifeLightImage: json["lifeLightImage"],
    anubhutiImage: json["anubhutiImage"],
    sgsiPdf: json["sgsiPdf"],
    socialLinks: json["socialLinks"] == null
        ? null
        : SocialLinks.fromJson(json["socialLinks"]),
    supportEmail: json["supportEmail"],
    supportPhone: json["supportPhone"],
    supportWhatsApp: json["supportWhatsApp"],
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    webSiteUrl: json["webSiteUrl"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "address": address,
    "appName": appName,
    "appStoreId": appStoreId,
    "appStoreUrl": appStoreUrl,
    "createdAt": createdAt?.toIso8601String(),
    "logo": logo,
    "playStoreId": playStoreId,
    "playStoreUrl": playStoreUrl,
    "lifeLightImage": lifeLightImage,
    "anubhutiImage": anubhutiImage,
    "sgsiPdf": sgsiPdf,
    "socialLinks": socialLinks?.toJson(),
    "supportEmail": supportEmail,
    "supportPhone": supportPhone,
    "supportWhatsApp": supportWhatsApp,
    "updatedAt": updatedAt?.toIso8601String(),
    "webSiteUrl": webSiteUrl,
  };
}

class SocialLinks {
  String? facebook;
  String? instagram;
  String? twitter;
  String? linkedin;
  String? youtube;
  String? whatsapp;
  String? id;

  SocialLinks({
    this.facebook,
    this.instagram,
    this.twitter,
    this.linkedin,
    this.youtube,
    this.whatsapp,
    this.id,
  });

  factory SocialLinks.fromRawJson(String str) =>
      SocialLinks.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SocialLinks.fromJson(Map<String, dynamic> json) => SocialLinks(
    facebook: json["facebook"],
    instagram: json["instagram"],
    twitter: json["twitter"],
    linkedin: json["linkedin"],
    youtube: json["youtube"],
    whatsapp: json["whatsapp"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "facebook": facebook,
    "instagram": instagram,
    "twitter": twitter,
    "linkedin": linkedin,
    "youtube": youtube,
    "whatsapp": whatsapp,
    "_id": id,
  };
}
