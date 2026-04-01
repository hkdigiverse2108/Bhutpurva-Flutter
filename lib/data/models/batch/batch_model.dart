class BatchModel {
  final String id;
  final String name;
  final GroupSummaryModel groupId;
  final List<String> monitorIds;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<BatchStudentModel> students;
  final int studentCount;

  BatchModel({
    required this.id,
    required this.name,
    required this.groupId,
    required this.monitorIds,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.students,
    required this.studentCount,
  });

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    return BatchModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      groupId: GroupSummaryModel.fromJson(json['groupId'] ?? {}),
      monitorIds: (json['monitorIds'] as List? ?? [])
          .map((e) => e is Map ? (e['_id'] ?? '') as String : e.toString())
          .toList(),
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      students: (json['students'] as List? ?? [])
          .map((e) => BatchStudentModel.fromJson(e))
          .toList(),
      studentCount: json['studentCount'] ?? 0,
    );
  }
}

class GroupSummaryModel {
  final String id;
  final String name;
  final List<String> leaderIds;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  GroupSummaryModel({
    required this.id,
    required this.name,
    required this.leaderIds,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GroupSummaryModel.fromJson(Map<String, dynamic> json) {
    return GroupSummaryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      leaderIds: List<String>.from(json['leaderIds'] ?? []),
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class BatchStudentModel {
  final String id;
  final String email;
  final String name;
  final String surname;
  final String phoneNumber;
  final String currentCity;
  final bool isVerified;
  final double profileCompletion; // Added as per user feedback

  BatchStudentModel({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.currentCity,
    required this.isVerified,
    this.profileCompletion = 0.0,
  });

  String get fullName => "$name $surname";

  factory BatchStudentModel.fromJson(Map<String, dynamic> json) {
    return BatchStudentModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      currentCity: json['currentCity'] ?? '',
      isVerified: json['isVerified'] ?? false,
      profileCompletion: (json['profileCompletion'] as num? ?? 0.0).toDouble(),
    );
  }
}
