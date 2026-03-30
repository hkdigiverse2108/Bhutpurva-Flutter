class ProgramModel {
  final String id;
  final String name;
  final BatchBriefModel? batchId;
  final String? description;
  final DateTime? date;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProgramModel({
    required this.id,
    required this.name,
    this.batchId,
    this.description,
    this.date,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });

  factory ProgramModel.empty() {
    return ProgramModel(id: '', name: '');
  }

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      batchId: json['batchId'] is Map<String, dynamic>
          ? BatchBriefModel.fromJson(json['batchId'])
          : null,
      description: json['description'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      isDeleted: json['isDeleted'] ?? false,
      createdAt:
          json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}

class BatchBriefModel {
  final String id;
  final String name;
  final bool isActive;

  BatchBriefModel({required this.id, required this.name, required this.isActive});

  factory BatchBriefModel.fromJson(Map<String, dynamic> json) {
    return BatchBriefModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}
