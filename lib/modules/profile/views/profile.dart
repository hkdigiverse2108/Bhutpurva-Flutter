import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/constants/app_images.dart';
import 'package:gurukul_bhutpurva/modules/profile/controllers/profile_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class Profile extends GetView<ProfileController> {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: Icon(
          Icons.person,
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
        actions: [
          Icon(
            PhosphorIconsFill.notification,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ],
        actionsPadding: const EdgeInsets.only(right: 16),
        title: Text(
          "Gurukul Bhutpurva",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).shadowColor.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Profile Picture Section
                    // Profile Picture Section
                    GestureDetector(
                      onTap: controller.openImagePicker,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Obx(() {
                            final imagePath = controller.profileImagePath.value;
                            final hasImage = imagePath.isNotEmpty;

                            ImageProvider? imageProvider;
                            if (hasImage) {
                              if (imagePath.startsWith('http')) {
                                imageProvider = NetworkImage(imagePath);
                              } else if (imagePath.contains('uploads')) {
                                final cleanPath = imagePath.startsWith('/')
                                    ? imagePath.substring(1)
                                    : imagePath;
                                imageProvider = NetworkImage(
                                  '${ApiConstants.baseUrl}/$cleanPath',
                                );
                              } else {
                                imageProvider = FileImage(File(imagePath));
                              }
                            }

                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).cardColor,
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                                image: hasImage && imageProvider != null
                                    ? DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: hasImage
                                  ? null
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_a_photo_outlined,
                                          color: Theme.of(context).primaryColor,
                                          size: 24,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Upload Your \nPhoto',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).primaryColor,
                                                fontSize: 10,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                            );
                          }),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Obx(() {
                                return Icon(
                                  controller.profileImagePath.value.isNotEmpty
                                      ? Icons.edit
                                      : Icons.add,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // User Name
                    Text(
                      controller.fullName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bhutpurva DUID : 6117',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Profile Completion
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Your profile is ${(controller.profileProgress * 100).toInt()}% Complete',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Menu Items
              const SizedBox(height: 12),
              _buildMenuItem(
                svgAsset: AppImages.profile,
                title: 'Update Your Profile',
                onTap: () => Get.toNamed(AppRoutes.updateProfile),
              ),
              _buildMenuItem(
                icon: Icons.mail,
                title: 'Manage Login Emails',
                onTap: () => controller.navigateToEmails(),
              ),
              _buildMenuItem(
                svgAsset: AppImages.family,
                title: 'Manage Family',
                onTap: () => controller.navigateToFamily(),
              ),
              _buildMenuItem(
                svgAsset: AppImages.userSwitch,
                title: 'Switch Profile',
                onTap: () => Get.toNamed(AppRoutes.switchProfile),
              ),
              _buildMenuItem(
                icon: PhosphorIconsBold.trash,
                title: 'Delete Your Profile',
                onTap: () => controller.openDeleteAccountPopup(),
              ),
              _buildMenuItem(
                svgAsset: AppImages.help,
                title: 'Get Help',
                onTap: () {
                  Get.toNamed(AppRoutes.technicalSupport);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    IconData? icon,
    String? svgAsset,
    String? svgUrl,
    required String title,
    required VoidCallback onTap,
  }) {
    assert(
      icon != null || svgAsset != null || svgUrl != null,
      'Provide either icon, svgAsset, or svgUrl',
    );

    final theme = Theme.of(Get.context!);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            /// ICON / SVG CONTAINER
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: _buildLeadingIcon(
                  theme: theme,
                  icon: icon,
                  svgAsset: svgAsset,
                  svgUrl: svgUrl,
                ),
              ),
            ),

            const SizedBox(width: 16),

            /// TITLE
            Expanded(child: Text(title, style: theme.textTheme.titleMedium)),

            /// ARROW
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: theme.textTheme.bodySmall?.color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingIcon({
    required ThemeData theme,
    IconData? icon,
    String? svgAsset,
    String? svgUrl,
  }) {
    final color = theme.primaryColor;

    if (svgAsset != null) {
      return SvgPicture.asset(
        svgAsset,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }

    if (svgUrl != null) {
      return SvgPicture.network(
        svgUrl,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        placeholderBuilder: (_) => const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Icon(icon, color: color, size: 24);
  }
}
