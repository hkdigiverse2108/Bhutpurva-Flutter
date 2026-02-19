class MemberModel {
  final String id;
  final String name;
  final String mobile;
  final double profileCompletion; // 0.0 → 1.0
  final bool isVerified;

  MemberModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.profileCompletion,
    required this.isVerified,
  });

  // Optional (API ready)
  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'],
      name: json['name'],
      mobile: json['mobile'],
      profileCompletion: (json['profileCompletion'] as num).toDouble(),
      isVerified: json['isVerified'],
    );
  }
}
