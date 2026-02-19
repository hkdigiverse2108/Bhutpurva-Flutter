import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';

class AttendanceModel {
  final String id;
  final String name;
  final String mobile;
  final double profileCompletion; // 0.0 → 1.0
  final Rx<AttendanceType> attendanceType;
  final DateTime createdAt;

  AttendanceModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.profileCompletion,
    AttendanceType? attendanceType,
    required this.createdAt,
  }) : attendanceType = (attendanceType ?? AttendanceType.notSelected).obs;

  // Optional (API ready)
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      name: json['name'],
      mobile: json['mobile'],
      profileCompletion: (json['profileCompletion'] as num).toDouble(),
      attendanceType: AttendanceType.values.firstWhere(
        (e) => e.name == json['attendanceType'],
        orElse: () => AttendanceType.notSelected,
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
