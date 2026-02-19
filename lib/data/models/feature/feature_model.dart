import 'package:flutter/material.dart';

class FeatureItem {
  final String title;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback? onTap;

  FeatureItem(this.title, this.icon, this.colors, {this.onTap});
}
