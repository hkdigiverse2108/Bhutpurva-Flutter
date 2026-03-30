import 'dart:convert' show json;

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/data/models/settings/settings_model.dart';
import 'package:gurukul_bhutpurva/data/models/user/stored_profile.dart';
import 'package:gurukul_bhutpurva/data/models/user/user_model.dart';

class StorageService extends GetxService {
  late GetStorage _box;

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  // Generic Methods
  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  Future<void> clear() async {
    await _box.erase();
  }

  bool has(String key) {
    return _box.hasData(key);
  }

  // Auth Helpers
  String? get token => read<String>(StorageKeys.token);

  Future<void> saveToken(String token) async {
    await write(StorageKeys.token, token);
    await write(StorageKeys.isLoggedIn, true);
  }

  Future<void> clearSession() async {
    await remove(StorageKeys.profileType);
    await remove(StorageKeys.token);
    await remove(StorageKeys.user);
    await write(StorageKeys.isLoggedIn, false);
  }

  bool get isLoggedIn => read<bool>(StorageKeys.isLoggedIn) ?? false;

  set isLoggedIn(bool value) => write(StorageKeys.isLoggedIn, value);

  // User Helpers
  // Map<String, dynamic>? get user =>
  //     read<Map<String, dynamic>>(StorageKeys.user);

  bool get isUser => profileType == ProfileType.user;

  bool get isConvener => profileType == ProfileType.convener;

  bool get isLeader => profileType == ProfileType.leader;

  Future<void> saveUser(UserModel userData) async {
    await write(StorageKeys.user, userData.toRawJson());
  }

  UserModel get user {
    final value = read(StorageKeys.user);
    return UserModel.fromRawJson(value ?? "{}");
  }

  Future<void> saveProfileType(ProfileType type) async {
    await write(StorageKeys.profileType, type.name);
  }

  ProfileType get profileType {
    final value = read<String>(StorageKeys.profileType);
    return ProfileType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ProfileType.user,
    );
  }

  Future<void> saveSettings(SettingsModel settings) async {
    await write(StorageKeys.settings, settings.toRawJson());
  }

  SettingsModel get settings {
    final value = read<String>(StorageKeys.settings);
    return SettingsModel.fromRawJson(value ?? "{}");
  }

  // ──────────────────────────────────────────────
  // Multi-Profile Management
  // ──────────────────────────────────────────────

  /// Returns all locally stored profiles.
  List<StoredProfile> get allProfiles {
    final raw = read<String>(StorageKeys.profiles);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = json.decode(raw);
      return list.map((e) => StoredProfile.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Saves the full profiles list.
  Future<void> _saveAllProfiles(List<StoredProfile> profiles) async {
    final encoded = json.encode(profiles.map((p) => p.toJson()).toList());
    await write(StorageKeys.profiles, encoded);
  }

  /// Index of the currently active profile in [allProfiles].
  int get activeProfileIndex =>
      read<int>(StorageKeys.activeProfileIndex) ?? 0;

  /// Adds or updates a profile in the local list.
  /// If a profile with the same user ID exists, it gets updated.
  /// Returns the index of the added/updated profile.
  Future<int> addProfile(String token, UserModel user) async {
    final profiles = allProfiles;
    final existingIndex = profiles.indexWhere(
      (p) => p.user.id == user.id,
    );

    if (existingIndex >= 0) {
      // Update existing profile
      profiles[existingIndex] = StoredProfile(token: token, user: user);
      await _saveAllProfiles(profiles);
      return existingIndex;
    } else {
      // Add new profile
      profiles.add(StoredProfile(token: token, user: user));
      await _saveAllProfiles(profiles);
      return profiles.length - 1;
    }
  }

  /// Switches the active session to the profile at [index].
  Future<void> switchToProfile(int index) async {
    final profiles = allProfiles;
    if (index < 0 || index >= profiles.length) return;

    final profile = profiles[index];
    await write(StorageKeys.activeProfileIndex, index);
    await saveToken(profile.token);
    await saveUser(profile.user);
    await saveProfileType(profile.user.role ?? ProfileType.user);
  }

  /// Removes the profile at [index] from the stored list.
  /// Returns the updated list length.
  Future<int> removeProfile(int index) async {
    final profiles = allProfiles;
    if (index < 0 || index >= profiles.length) return profiles.length;

    profiles.removeAt(index);
    await _saveAllProfiles(profiles);

    // Adjust active index
    if (profiles.isEmpty) {
      await remove(StorageKeys.activeProfileIndex);
    } else {
      final newIndex = index >= profiles.length ? profiles.length - 1 : index;
      await write(StorageKeys.activeProfileIndex, newIndex);
    }

    return profiles.length;
  }

  // App Settings
  String get language => read<String>(StorageKeys.language) ?? 'en';

  Future<void> setLanguage(String value) async {
    await write(StorageKeys.language, value);
  }

  bool get isOnboardingDone => read<bool>(StorageKeys.onboardingDone) ?? false;

  Future<void> completeOnboarding() async {
    await write(StorageKeys.onboardingDone, true);
  }
}

class StorageKeys {
  static const token = 'token';
  static const user = 'user';
  static const isLoggedIn = 'is_logged_in';
  static const themeMode = 'theme_mode';
  static const language = 'language';
  static const onboardingDone = 'onboarding_done';
  static const profileType = 'profile_type';
  static const settings = 'settings';
  static const profiles = 'stored_profiles';
  static const activeProfileIndex = 'active_profile_index';
}
