import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/constants/app_images.dart';
import 'package:gurukul_bhutpurva/core/constants/app_size.dart';
import 'package:gurukul_bhutpurva/modules/auth/controllers/login_controller.dart';
import 'package:gurukul_bhutpurva/shared/widgets/buttons/app_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AccountNotFound extends GetView<LoginController> {
  const AccountNotFound({super.key});

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
                            'Gurukul Bhutpurva',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                          ),

                          const SizedBox(height: AppSize.lg),

                          Text(
                            'Sevak Account Not Found',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                          ),

                          const Gap(AppSize.lg),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              "🔹 If you have an account, and seeing this page close the app and try again.",
                            ),
                          ),
                          const Gap(AppSize.sm),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              "🔹 And if this issue continue contact us.",
                            ),
                          ),
                          const Spacer(),

                          // 🔹 Register (Primary)
                          AppButton(
                            icon: PhosphorIconsBold.user,
                            title: 'Register',
                            backgroundColor: AppColors.primary,
                            textColor: AppColors.textWhite,
                            onTap: () {
                              controller.navigateToRegister();
                            },
                          ),

                          const Gap(AppSize.lg),

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
