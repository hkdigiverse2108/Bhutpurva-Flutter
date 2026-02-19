import 'package:gurukul_bhutpurva/data/models/user/user_model.dart';

class VerificationModel {
  UserModel user;
  String token;

  VerificationModel({required this.user, required this.token});

  factory VerificationModel.fromJson(Map<String, dynamic> json) =>
      VerificationModel(
        user: UserModel.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {"user": user.toJson(), "token": token};
}
