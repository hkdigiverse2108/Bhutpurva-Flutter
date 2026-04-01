import 'dart:convert';

class AttendanceModel {
  final String id;
  final Id programId;
  final Id batchId;
  final List<Student> students;
  final DateTime date;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  AttendanceModel({
    required this.id,
    required this.programId,
    required this.batchId,
    required this.students,
    required this.date,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttendanceModel.fromRawJson(String str) =>
      AttendanceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      AttendanceModel(
        id: json["_id"],
        programId: Id.fromJson(json["programId"]),
        batchId: Id.fromJson(json["batchId"]),
        students: List<Student>.from(
          json["students"].map((x) => Student.fromJson(x)),
        ),
        date: DateTime.parse(json["date"]),
        isDeleted: json["isDeleted"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "programId": programId.toJson(),
    "batchId": batchId.toJson(),
    "students": List<dynamic>.from(students.map((x) => x.toJson())),
    "date": date.toIso8601String(),
    "isDeleted": isDeleted,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class Id {
  final String id;
  final String name;

  Id({required this.id, required this.name});

  factory Id.fromRawJson(String str) => Id.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Id.fromJson(Map<String, dynamic> json) =>
      Id(id: json["_id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"_id": id, "name": name};
}

class Student {
  final StudentId studentId;
  final bool? isPresent;

  Student({required this.studentId, required this.isPresent});

  factory Student.fromRawJson(String str) => Student.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    studentId: StudentId.fromJson(json["studentId"]),
    isPresent: json["isPresent"],
  );

  Map<String, dynamic> toJson() => {
    "studentId": studentId.toJson(),
    "isPresent": isPresent,
  };
}

class StudentId {
  final String id;
  final String name;
  final String fatherName;
  final String surname;
  final String phoneNumber;
  final String whatsappNumber;

  StudentId({
    required this.id,
    required this.name,
    required this.fatherName,
    required this.surname,
    required this.phoneNumber,
    required this.whatsappNumber,
  });

  factory StudentId.fromRawJson(String str) =>
      StudentId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StudentId.fromJson(Map<String, dynamic> json) => StudentId(
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

class SAttendanceModel {
  final String programName;
  final String attendanceId;
  final DateTime date;
  final bool isPresent;

  SAttendanceModel({
    required this.programName,
    required this.attendanceId,
    required this.date,
    required this.isPresent,
  });

  factory SAttendanceModel.fromRawJson(String str) =>
      SAttendanceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SAttendanceModel.fromJson(Map<String, dynamic> json) =>
      SAttendanceModel(
        programName: json["programName"],
        attendanceId: json["attendanceId"],
        date: DateTime.parse(json["date"]),
        isPresent: json["isPresent"],
      );

  Map<String, dynamic> toJson() => {
    "programName": programName,
    "attendanceId": attendanceId,
    "date": date.toIso8601String(),
    "isPresent": isPresent,
  };
}