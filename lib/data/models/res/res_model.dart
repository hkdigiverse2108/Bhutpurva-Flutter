class ResModel {
  final int status;
  final String? message;
  final dynamic data;
  final String? error;

  ResModel({required this.status, this.message, this.data, this.error});

  factory ResModel.fromJson(Map<String, dynamic> json) {
    return ResModel(
      status: json['status'] ?? 0,
      message: json['message'] is Map && (json['message'] as Map).isEmpty
          ? null
          : json['message']?.toString(),
      data: json['data'],
      error: json['error'] is Map && (json['error'] as Map).isEmpty
          ? null
          : json['error']?.toString(),
    );
  }
}
