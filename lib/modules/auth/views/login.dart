import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/constants/app_images.dart';
import 'package:gurukul_bhutpurva/core/constants/app_size.dart';
import 'package:gurukul_bhutpurva/modules/auth/controllers/login_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class Login extends GetView<LoginController> {
  const Login({super.key});

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
                          const Gap(AppSize.md),

                          // Welcome text
                          Text(
                            'Welcome to Bhutpurva',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                          ),

                          const SizedBox(height: AppSize.sm),

                          Text(
                            'Sign in to continue',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.textSecondary),
                          ),

                          const SizedBox(height: AppSize.xl),

                          // 🔹 Google Sign In (Secondary)
                          Obx(
                            () => _AuthButton(
                              icon: PhosphorIconsBold.googleLogo,
                              title: 'Sign in with Google',
                              backgroundColor: AppColors.white,
                              textColor: AppColors.textPrimary,
                              borderColor: AppColors.borderPrimary,
                              isLoading: controller.isGoogleLoading.value,
                              onTap: () {
                                controller.loginWithGoogle();
                              },
                            ),
                          ),

                          const SizedBox(height: AppSize.lg),

                          // 🔹 OTP Sign In (Primary)
                          _AuthButton(
                            icon: PhosphorIconsBold.phone,
                            title: 'Sign in with Phone',
                            backgroundColor: AppColors.primary,
                            textColor: AppColors.textWhite,
                            onTap: () {
                              controller.navigateToPhone();
                            },
                          ),
                          Gap(AppSize.sm),
                          Text("OR"),
                          Gap(AppSize.sm),
                          _AuthButton(
                            icon: PhosphorIconsBold.user,
                            title: 'Register',
                            backgroundColor: AppColors.primary,
                            textColor: AppColors.textWhite,
                            onTap: () {
                              controller.navigateToRegister();
                            },
                          ),

                          const Spacer(),

                          // Terms & Conditions
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSize.sm,
                            ),
                            child: Text.rich(
                              TextSpan(
                                text: 'By signing in, you agree to our ',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.textSecondary),
                                children: [
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: Theme.of(context).textTheme.bodySmall
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

class _AuthButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;
  final bool isLoading;

  const _AuthButton({
    required this.icon,
    required this.title,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSize.buttonHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: borderColor != null
              ? BorderSide(color: borderColor!)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.buttonRadius),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: textColor),
                  const SizedBox(width: AppSize.sm),
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: AppSize.fontSizeMd,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
