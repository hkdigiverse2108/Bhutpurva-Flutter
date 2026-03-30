import 'dart:convert' show json;

import 'package:gurukul_bhutpurva/data/models/user/user_model.dart';

/// A model that bundles an auth token with its associated user.
/// Used to store multiple accounts locally for profile switching.
class StoredProfile {
  final String token;
  final UserModel user;

  StoredProfile({required this.token, required this.user});

  factory StoredProfile.fromRawJson(String str) =>
      StoredProfile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StoredProfile.fromJson(Map<String, dynamic> json) => StoredProfile(
    token: json["token"] ?? "",
    user: UserModel.fromJson(json["user"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user.toJson(),
  };
}
