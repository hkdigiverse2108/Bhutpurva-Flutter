import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/constants/app_images.dart';
import 'package:gurukul_bhutpurva/core/constants/app_size.dart';
import 'package:gurukul_bhutpurva/data/models/user/stored_profile.dart';
import 'package:gurukul_bhutpurva/modules/auth/controllers/switch_profile_controller.dart';
import 'package:gurukul_bhutpurva/shared/widgets/buttons/app_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SwitchProfile extends GetView<SwitchProfileController> {
  const SwitchProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          image: DecorationImage(
            image: AssetImage(AppImages.topImage),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            // 🔹 Top image area (reserved)
            Expanded(flex: 3, child: SizedBox()),

            // 🔹 Bottom container
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSize.cardRadiusLg),
                    topRight: Radius.circular(AppSize.cardRadiusLg),
                  ),
                ),
                child: Stack(
                  children: [
                    Opacity(
                      opacity: 0.2,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AppImages.bg),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSize.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Welcome text
                          Text(
                            'Gurukul Bhutpurva',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                          ),

                          const SizedBox(height: AppSize.sm),

                          Text(
                            'Select Profile',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                          ),

                          const Gap(AppSize.sm),

                          // 🔹 Dynamic profiles list
                          Expanded(
                            child: Obx(() {
                              if (controller.profiles.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No profiles yet.\nRegister or log in to add one.',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                );
                              }

                              return SingleChildScrollView(
                                child: Column(
                                  children: List.generate(
                                    controller.profiles.length,
                                    (index) {
                                      final profile =
                                          controller.profiles[index];
                                      final isActive = index ==
                                          controller.activeIndex.value;
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: AppSize.sm,
                                        ),
                                        child: UserCard(
                                          profile: profile,
                                          isActive: isActive,
                                          onTap: () =>
                                              controller.selectProfile(index),
                                          onRemove: () =>
                                              _confirmRemove(context, index),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }),
                          ),

                          const Gap(AppSize.sm),
                          Text("OR"),
                          const Gap(AppSize.sm),

                          // 🔹 Add Account
                          AppButton(
                            icon: PhosphorIconsBold.userPlus,
                            title: 'Add Account',
                            backgroundColor: AppColors.primary,
                            textColor: AppColors.textWhite,
                            onTap: controller.addNewAccount,
                          ),

                          const Gap(AppSize.md),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSize.sm,
                            ),
                            child: Text.rich(
                              TextSpan(
                                text: 'Need Help? ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                                children: [
                                  TextSpan(
                                    text: 'Contact Us',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmRemove(BuildContext context, int index) {
    final profile = controller.profiles[index];
    final name = _buildFullName(profile);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Remove Account'),
        content: Text(
          'Are you sure you want to remove "$name" from this device?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.removeProfile(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Remove',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  static String _buildFullName(StoredProfile profile) {
    final parts = [
      profile.user.name,
      profile.user.fatherName,
      profile.user.surname,
    ].where((p) => p != null && p.isNotEmpty);
    return parts.isEmpty ? 'Unknown' : parts.join(' ');
  }
}

class UserCard extends StatelessWidget {
  final StoredProfile profile;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const UserCard({
    super.key,
    required this.profile,
    required this.isActive,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final fullName = SwitchProfile._buildFullName(profile);
    final subtitle =
        profile.user.email ?? profile.user.phoneNumber ?? '';
    final role = profile.user.role?.name ?? 'user';

    // Build image provider
    ImageProvider? imageProvider;
    final img = profile.user.image;
    if (img != null && img.isNotEmpty) {
      if (img.startsWith('http')) {
        imageProvider = NetworkImage(img);
      } else {
        final cleanPath = img.startsWith('/') ? img.substring(1) : img;
        imageProvider =
            NetworkImage('${ApiConstants.baseUrl}/$cleanPath');
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSize.cardRadiusLg),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSize.cardRadiusLg),
            border: Border.all(
              color: isActive
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : theme.dividerColor.withValues(alpha: 0.08),
              width: isActive ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              /// AVATAR
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isActive
                        ? [AppColors.primary, AppColors.black]
                        : [Colors.grey.shade400, Colors.grey.shade300],
                  ),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: imageProvider != null
                      ? ClipOval(
                          child: Image(
                            image: imageProvider,
                            width: 54,
                            height: 54,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _FallbackAvatar(name: fullName),
                          ),
                        )
                      : _FallbackAvatar(name: fullName),
                ),
              ),

              const Gap(AppSize.md),

              /// USER INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        role.capitalizeFirst ?? role,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? AppColors.primary
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// ACTIVE INDICATOR / REMOVE
              if (isActive)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    PhosphorIconsFill.checkCircle,
                    size: 22,
                    color: AppColors.primary,
                  ),
                )
              else
                IconButton(
                  icon: Icon(
                    PhosphorIconsRegular.caretRight,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: onTap,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FallbackAvatar extends StatelessWidget {
  final String name;

  const _FallbackAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      width: 54,
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Text(
        initial,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
