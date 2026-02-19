import 'dart:developer';
import 'dart:io';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
// ignore: depend_on_referenced_packages
import 'package:mime/mime.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/services/api_service.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';
import 'package:gurukul_bhutpurva/modules/profile/widgets/bullet_text.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final StorageService storage = Get.find();
  final apiService = ApiService();

  final uploadingImage = false.obs;

  String get fullName =>
      "${storage.user.name} ${storage.user.fatherName} ${storage.user.surname}"
          .toUpperCase();

  double get profileProgress {
    final user = storage.user;
    int total = 0;
    int filled = 0;

    void check(dynamic value) {
      total++;
      if (value == null) return;
      if (value is String && value.trim().isNotEmpty) {
        filled++;
      } else if (value is List && value.isNotEmpty) {
        filled++;
      } else if (value is! String && value is! List) {
        filled++;
      }
    }

    check(user.name);
    check(user.fatherName);
    check(user.surname);
    check(user.email);
    check(user.phoneNumber);
    check(user.whatsappNumber);
    check(user.gender);
    check(user.hrNo);
    check(user.currentCity);
    check(user.occupation);
    check(user.maritalStatus);
    check(user.bloodGroup);
    check(user.skill);
    check(user.addressIds);
    check(user.professions);
    check(user.educations);
    check(user.talents);
    check(user.awards);
    check(user.class10);
    check(user.class12);
    check(user.studyId);

    if (total == 0) return 0.0;
    return (filled / total);
  }

  void navigateToEmails() {
    Get.toNamed(AppRoutes.emails);
  }

  void navigateToFamily() {
    Get.toNamed(AppRoutes.family);
  }

  final ImagePicker _picker = ImagePicker();
  RxString profileImagePath = ''.obs;

  @override
  void onInit() {
    profileImagePath.value = storage.user.image ?? '';
    super.onInit();
  }

  void openImagePicker() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// DRAG HANDLE
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Change Profile Picture',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageOption(
                    icon: PhosphorIconsRegular.camera,
                    label: 'Camera',
                    onTap: () {
                      Get.back();
                      pickImage(ImageSource.camera);
                    },
                  ),
                  _buildImageOption(
                    icon: PhosphorIconsRegular.image,
                    label: 'Gallery',
                    onTap: () {
                      Get.back();
                      pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        profileImagePath.value = image.path;
        uploadImage(File(image.path));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void uploadImage(File file) async {
    try {
      uploadingImage.value = true;
      final mimeType = lookupMimeType(file.path);
      final contentType = mimeType != null ? MediaType.parse(mimeType) : null;

      final ResModel response = await apiService.postMultipart(
        ApiConstants.image,
        files: [
          await http.MultipartFile.fromPath(
            'files',
            file.path,
            contentType: contentType,
          ),
        ],
      );
      if (response.status == 200 || response.status == 201) {
        if (response.data != null &&
            response.data['files'] != null &&
            (response.data['files'] as List).isNotEmpty) {
          final filePath = response.data['files'][0];

          // Call update profile image API
          final updateResponse = await apiService.put(
            ApiConstants.updateProfileImage,
            body: {"userId": storage.user.id, "image": filePath},
          );

          if (updateResponse.status == 200 || updateResponse.status == 201) {
            var user = storage.user;
            user.image = filePath;
            await storage.saveUser(user);
            log(user.image.toString());
            profileImagePath.value = user.image!;
            AppSnackbar.success('Profile picture updated successfully');
          } else {
            AppSnackbar.error(
              updateResponse.message ?? 'Failed to update profile picture',
            );
          }
        } else {
          AppSnackbar.error('Failed to get uploaded file path');
        }
      } else {
        AppSnackbar.error(response.message ?? 'Failed to upload image');
      }
    } catch (e) {
      log(e.toString());
      AppSnackbar.error('Failed to upload image: $e');
    } finally {
      uploadingImage.value = false;
    }
  }

  void openDeleteAccountPopup() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// DRAG HANDLE
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ICON + TITLE
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      PhosphorIconsRegular.trash,
                      color: Colors.red,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Delete Account',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// DESCRIPTION
              const Text(
                'Requesting account deletion will permanently remove your data from Gurukul Bhutpurva.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Color(0xFF444444),
                ),
              ),

              const SizedBox(height: 16),

              /// INFO CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    BulletText(
                      text:
                          'Your profile, personal data, and attendance records will be permanently erased.',
                    ),
                    BulletText(
                      text:
                          'Deletion requests are reviewed and processed within 5–7 working days.',
                    ),
                    BulletText(
                      text:
                          'A final verification call will be made before deletion.',
                    ),
                    BulletText(
                      text:
                          'After verification, you will be logged out automatically.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              /// WARNING TEXT
              const Text(
                'This action cannot be undone.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),

              const SizedBox(height: 22),

              /// ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: Get.back,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Delete Account',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      barrierColor: Colors.black.withValues(alpha: 0.4),
    );
  }
}
