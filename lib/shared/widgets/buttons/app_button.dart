import 'package:flutter/material.dart';
import 'package:gurukul_bhutpurva/core/constants/app_size.dart';

class AppButton extends StatelessWidget {
  final IconData? icon;
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;
  final bool isLoading;

  const AppButton({
    super.key,
    this.icon,
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
        onPressed: onTap,
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
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: textColor),
                    const SizedBox(width: AppSize.sm),
                  ],
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
