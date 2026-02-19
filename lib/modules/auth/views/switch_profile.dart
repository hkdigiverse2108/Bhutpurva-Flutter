import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/constants/app_images.dart';
import 'package:gurukul_bhutpurva/core/constants/app_size.dart';
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
            // 🔹 Top image area (ignored / reserved)
            Expanded(flex: 3, child: SizedBox()),

            // 🔹 Bottom login container
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
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                          ),

                          const SizedBox(height: AppSize.sm),

                          Text(
                            'Select Profile',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                          ),

                          const Gap(AppSize.sm),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  UserCard(
                                    avatar: AssetImage(
                                      'assets/images/avatar.png',
                                    ),
                                    name: 'John Doe',
                                    email: 'john.doe@example.com',
                                    onTap: () {
                                      Get.toNamed(AppRoutes.navigation);
                                    },
                                  ),
                                  const Gap(AppSize.sm),
                                  UserCard(
                                    avatar: AssetImage(
                                      'assets/images/avatar.png',
                                    ),
                                    name: 'Jane Smith',
                                    email: 'jane.smith@example.com',
                                    onTap: () {
                                      Get.toNamed(AppRoutes.navigation);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Gap(AppSize.sm),
                          Text("OR"),
                          const Gap(AppSize.sm),
                          // 🔹 Register (Primary)
                          AppButton(
                            icon: PhosphorIconsBold.user,
                            title: 'Register',
                            backgroundColor: AppColors.primary,
                            textColor: AppColors.textWhite,
                            onTap: () {
                              Get.toNamed(AppRoutes.register);
                            },
                          ),

                          const Gap(AppSize.md),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSize.sm,
                            ),
                            child: Text.rich(
                              TextSpan(
                                text: 'Need Help? ',
                                style: Theme.of(context).textTheme.bodyMedium
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
}

class UserCard extends StatelessWidget {
  final String name;
  final String email;
  final ImageProvider avatar;
  final VoidCallback onTap;

  const UserCard({
    super.key,
    required this.name,
    required this.email,
    required this.avatar,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              color: theme.dividerColor.withValues(alpha: 0.08),
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
              /// AVATAR WITH GRADIENT RING + ERROR HANDLING
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.black],
                  ),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: _AvatarImage(image: avatar, name: name),
                ),
              ),

              const Gap(AppSize.md),

              /// USER INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),

              /// ACTION ICON
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  PhosphorIconsRegular.caretRight,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarImage extends StatelessWidget {
  final ImageProvider image;
  final String name;

  const _AvatarImage({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image(
        image: image,
        width: 54,
        height: 54,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          /// FALLBACK WHEN IMAGE FAILS
          return _FallbackAvatar(name: name);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          /// LOADING STATE
          return const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
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
