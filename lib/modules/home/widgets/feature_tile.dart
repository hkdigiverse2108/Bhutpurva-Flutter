import 'package:flutter/material.dart';
import 'package:gurukul_bhutpurva/data/models/feature/feature_model.dart';

class FeatureGrid extends StatelessWidget {
  final List<FeatureItem> items;

  const FeatureGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (_, i) => FeatureTile(item: items[i]),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final FeatureItem item;

  const FeatureTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: item.onTap,
          child: Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: item.colors),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: item.colors.last.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(item.icon, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}
