import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/constants/app_images.dart';
import 'package:gurukul_bhutpurva/core/constants/app_size.dart';
import 'package:gurukul_bhutpurva/modules/auth/controllers/login_controller.dart';
import 'package:gurukul_bhutpurva/shared/widgets/buttons/app_button.dart';

class PhoneLogin extends GetView<LoginController> {
  const PhoneLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: isKeyboardOpen
                  ? 0
                  : MediaQuery.of(context).size.height * 0.40,
            ),

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(AppSize.md),

                          // Welcome text
                          Text(
                            'Login with Phone Number',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                          ),

                          const SizedBox(height: AppSize.sm),

                          Text(
                            'Make sure your are registered before logging in.',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.textSecondary),
                          ),

                          const SizedBox(height: AppSize.xl),

                          Form(
                            key: controller.formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: controller.phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    label: Text('Phone'),
                                  ),
                                  maxLength: 10,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a phone number';
                                    }
                                    if (!GetUtils.isPhoneNumber(value)) {
                                      return 'Please enter a valid phone number';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: AppSize.lg),

                          // 🔹 OTP Sign In (Primary)
                          Obx(
                            () => AppButton(
                              isLoading: controller.isLoading.value,
                              title: 'Get OTP',
                              backgroundColor: AppColors.primary,
                              textColor: AppColors.textWhite,
                              onTap: controller.getOTP,
                            ),
                          ),

                          const Spacer(),

                          // Terms & Conditions
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.sm,
                              ),
                              child: Text.rich(
                                TextSpan(
                                  text: 'By signing in, you agree to our ',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                  children: [
                                    TextSpan(
                                      text: 'Terms & Conditions',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
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
                          ),

                          const Gap(AppSize.md),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.sm,
                              ),
                              child: Text.rich(
                                TextSpan(
                                  text: 'Need Help? ',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
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
