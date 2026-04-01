class MonitorModel {
  final String id;
  final String name;
  final String mobile;
  final List<String> devoteeIds;
  List<String> assignedMembers;

  MonitorModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.devoteeIds,
    this.assignedMembers = const [],
  });

  factory MonitorModel.fromJson(Map<String, dynamic> json) {
    final user = json['userId'] as Map<String, dynamic>? ?? {};
    return MonitorModel(
      id: json['_id'] ?? '',
      name: user['name'] ?? '',
      mobile: user['phoneNumber'] ?? '',
      devoteeIds: List<String>.from(json['devoteeIds'] ?? []),
      assignedMembers: [],
    );
  }
}
