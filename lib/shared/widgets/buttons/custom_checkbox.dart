import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final double? size;
  final double? iconSize;
  final ValueChanged<bool> onChange;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;
  final IconData? icon;
  final bool isChecked;

  const CustomCheckbox({
    super.key,
    this.size,
    this.iconSize,
    required this.onChange,
    this.backgroundColor,
    this.iconColor,
    this.icon,
    this.borderColor,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChange(!isChecked),
      child: AnimatedContainer(
        height: size ?? 28,
        width: size ?? 28,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.0),
          color: isChecked
              ? backgroundColor ?? Colors.blue
              : Colors.transparent,
          border: Border.all(color: borderColor ?? Colors.black),
        ),
        child: isChecked
            ? Icon(
                icon ?? Icons.check,
                color: iconColor ?? Colors.white,
                size: iconSize ?? 20,
              )
            : null,
      ),
    );
  }
}
