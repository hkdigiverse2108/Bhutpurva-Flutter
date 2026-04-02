import 'dart:convert' show json;

import 'package:gurukul_bhutpurva/core/constants/enums.dart';

class UserModel {
  String? id;
  String? email;
  String? name;
  String? fatherName;
  String? surname;
  DateTime? birthDate;
  String? phoneNumber;
  String? whatsappNumber;
  String? gender;
  String? hrNo;
  ProfileType? role;
  String? currentCity;
  List<AddressId>? addressIds;
  String? occupation;
  List<String>? professions;
  List<dynamic>? educations;
  String? maritalStatus;
  String? bloodGroup;
  Class12Class? class10;
  Class12Class? class12;
  StudyId? studyId;
  String? skill;
  List<String>? talents;
  String? hobbies;
  List<String>? awards;
  bool? isDeleted;
  bool? isVerified;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? image;
  String? batchId;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.fatherName,
    this.surname,
    this.birthDate,
    this.phoneNumber,
    this.whatsappNumber,
    this.gender,
    this.hrNo,
    this.role,
    this.currentCity,
    this.addressIds,
    this.occupation,
    this.professions,
    this.educations,
    this.maritalStatus,
    this.bloodGroup,
    this.class10,
    this.class12,
    this.studyId,
    this.skill,
    this.talents,
    this.hobbies,
    this.awards,
    this.isDeleted,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.batchId,
  });

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["_id"] ?? json["id"],
    email: json["email"],
    name: json["name"],
    fatherName: json["fatherName"],
    surname: json["surname"],
    birthDate: json["birthDate"] == null
        ? null
        : DateTime.parse(json["birthDate"]),
    phoneNumber: json["phoneNumber"],
    whatsappNumber: json["whatsappNumber"],
    gender: json["gender"],
    hrNo: json["hrNo"],
    role: ProfileType.values.firstWhere(
      (e) => e.name == json["role"],
      orElse: () => ProfileType.user,
    ),
    currentCity: json["currentCity"],
    addressIds: json["addressIds"] == null
        ? []
        : List<AddressId>.from(
            json["addressIds"]!.map((x) => AddressId.fromJson(x)),
          ),
    occupation: json["occupation"],
    professions: json["professions"] == null
        ? []
        : List<String>.from(json["professions"]!.map((x) => x)),
    educations: json["educations"] == null
        ? []
        : List<dynamic>.from(json["educations"]!.map((x) => x)),
    hobbies: json["hobbies"],
    maritalStatus: json["maritalStatus"],
    bloodGroup: json["bloodGroup"],
    class10: json["class10"] == null
        ? null
        : Class12Class.fromJson(json["class10"]),
    class12: json["class12"] == null
        ? null
        : Class12Class.fromJson(json["class12"]),
    studyId: json["studyId"] == null ? null : StudyId.fromJson(json["studyId"]),
    skill: json["skill"],
    talents: json["talents"] == null
        ? []
        : List<String>.from(json["talents"]!.map((x) => x)),
    awards: json["awards"] == null
        ? []
        : List<String>.from(json["awards"]!.map((x) => x)),
    isDeleted: json["isDeleted"],
    isVerified: json["isVerified"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    image: json["image"],
    batchId: json["batchId"] is Map
        ? json["batchId"]["_id"]
        : json["batchId"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "name": name,
    "fatherName": fatherName,
    "surname": surname,
    "birthDate": birthDate?.toIso8601String(),
    "phoneNumber": phoneNumber,
    "whatsappNumber": whatsappNumber,
    "gender": gender,
    "hrNo": hrNo,
    "role": role?.name,
    "currentCity": currentCity,
    "addressIds": addressIds == null
        ? []
        : List<dynamic>.from(addressIds!.map((x) => x.toJson())),
    "occupation": occupation,
    "professions": professions == null
        ? []
        : List<dynamic>.from(professions!.map((x) => x)),
    "educations": educations == null
        ? []
        : List<dynamic>.from(educations!.map((x) => x)),
    "hobbies": hobbies,
    "maritalStatus": maritalStatus,
    "bloodGroup": bloodGroup,
    "class10": class10?.toJson(),
    "class12": class12?.toJson(),
    "studyId": studyId?.toJson(),
    "skill": skill,
    "talents": talents == null
        ? []
        : List<dynamic>.from(talents!.map((x) => x)),
    "awards": awards == null ? [] : List<dynamic>.from(awards!.map((x) => x)),
    "isDeleted": isDeleted,
    "isVerified": isVerified,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "image": image,
    "batchId": batchId,
  };
}

class AddressId {
  String? id;
  String? address;
  String? type;
  String? city;
  String? district;
  String? state;
  String? country;
  String? pincode;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  AddressId({
    this.id,
    this.address,
    this.type,
    this.city,
    this.district,
    this.state,
    this.country,
    this.pincode,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressId.fromJson(Map<String, dynamic> json) => AddressId(
    id: json["_id"],
    address: json["address"],
    type: json["type"],
    city: json["city"],
    district: json["district"],
    state: json["state"],
    country: json["country"],
    pincode: json["pincode"],
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "address": address,
    "type": type,
    "city": city,
    "district": district,
    "state": state,
    "country": country,
    "pincode": pincode,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class Class12Class {
  String? class1Class;
  bool? isStudied;
  String? branch;
  String? passingYear;
  String? medium;
  bool? hostel;
  String? id;

  Class12Class({
    this.class1Class,
    this.isStudied,
    this.branch,
    this.passingYear,
    this.medium,
    this.hostel,
    this.id,
  });

  factory Class12Class.fromJson(Map<String, dynamic> json) => Class12Class(
    class1Class: json["class"],
    isStudied: json["isStudied"] ?? json["isStudded"],
    branch: json["branch"],
    passingYear: json["passingYear"],
    medium: json["medium"],
    hostel: json["hostel"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "class": class1Class,
    "isStudied": isStudied,
    "branch": branch,
    "passingYear": passingYear,
    "medium": medium,
    "hostel": hostel,
    "_id": id,
  };
}

class StudyId {
  String? id;
  Classes? classes;
  DateTime? createdAt;
  DateTime? updatedAt;

  StudyId({this.id, this.classes, this.createdAt, this.updatedAt});

  factory StudyId.fromJson(Map<String, dynamic> json) => StudyId(
    id: json["_id"],
    classes: json["classes"] == null ? null : Classes.fromJson(json["classes"]),
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "classes": classes?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class Classes {
  Class1Class? class1;
  Class1Class? class2;
  Class1Class? class3;
  Class1Class? class4;
  Class1Class? class5;
  Class1Class? class6;
  Class1Class? class7;
  Class1Class? class8;
  Class1Class? class9;
  Class1Class? class10;
  Class1Class? class11;
  Class1Class? class12;

  Classes({
    this.class1,
    this.class2,
    this.class3,
    this.class4,
    this.class5,
    this.class6,
    this.class7,
    this.class8,
    this.class9,
    this.class10,
    this.class11,
    this.class12,
  });

  factory Classes.fromJson(Map<String, dynamic> json) => Classes(
    class1: json["class1"] == null
        ? null
        : Class1Class.fromJson(json["class1"]),
    class2: json["class2"] == null
        ? null
        : Class1Class.fromJson(json["class2"]),
    class3: json["class3"] == null
        ? null
        : Class1Class.fromJson(json["class3"]),
    class4: json["class4"] == null
        ? null
        : Class1Class.fromJson(json["class4"]),
    class5: json["class5"] == null
        ? null
        : Class1Class.fromJson(json["class5"]),
    class6: json["class6"] == null
        ? null
        : Class1Class.fromJson(json["class6"]),
    class7: json["class7"] == null
        ? null
        : Class1Class.fromJson(json["class7"]),
    class8: json["class8"] == null
        ? null
        : Class1Class.fromJson(json["class8"]),
    class9: json["class9"] == null
        ? null
        : Class1Class.fromJson(json["class9"]),
    class10: json["class10"] == null
        ? null
        : Class1Class.fromJson(json["class10"]),
    class11: json["class11"] == null
        ? null
        : Class1Class.fromJson(json["class11"]),
    class12: json["class12"] == null
        ? null
        : Class1Class.fromJson(json["class12"]),
  );

  Map<String, dynamic> toJson() => {
    "class1": class1?.toJson(),
    "class2": class2?.toJson(),
    "class3": class3?.toJson(),
    "class4": class4?.toJson(),
    "class5": class5?.toJson(),
    "class6": class6?.toJson(),
    "class7": class7?.toJson(),
    "class8": class8?.toJson(),
    "class9": class9?.toJson(),
    "class10": class10?.toJson(),
    "class11": class11?.toJson(),
    "class12": class12?.toJson(),
  };
}

class Class1Class {
  bool? isStudied;
  String? branch;

  Class1Class({this.isStudied, this.branch});

  factory Class1Class.fromJson(Map<String, dynamic> json) =>
      Class1Class(isStudied: json["isStudied"], branch: json["branch"]);

  Map<String, dynamic> toJson() => {"isStudied": isStudied, "branch": branch};
}
