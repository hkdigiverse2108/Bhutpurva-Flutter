import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;

  const CustomShimmer({
    super.key,
    required this.child,
    required this.isLoading,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.shade300,
      highlightColor: highlightColor ?? Colors.grey.shade100,
      child: _buildShimmerPlaceholder(child),
    );
  }

  Widget _buildShimmerPlaceholder(Widget widget) {
    // Text
    if (widget is Text) {
      return Container(
        height: 16,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
      );
    }
    // Icon
    if (widget is Icon) {
      double size = widget.size ?? 24;
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      );
    }
    // CircleAvatar
    if (widget is CircleAvatar) {
      double radius = widget.radius ?? 20;
      return CircleAvatar(radius: radius, backgroundColor: Colors.white);
    }
    // Image (covers Image, Image.network, etc.)
    if (widget is Image) {
      double width = widget.width ?? 48;
      double height = widget.height ?? 48;
      return Container(width: width, height: height, color: Colors.white);
    }
    // Row
    if (widget is Row) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: widget.mainAxisAlignment,
          crossAxisAlignment: widget.crossAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
          children: widget.children.map(_buildShimmerPlaceholder).toList(),
        ),
      );
    }
    // Column
    if (widget is Column) {
      return Column(
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        mainAxisSize: widget.mainAxisSize,
        children: widget.children.map(_buildShimmerPlaceholder).toList(),
      );
    }
    // Stack
    if (widget is Stack) {
      return Stack(
        alignment: widget.alignment,
        fit: widget.fit,
        clipBehavior: widget.clipBehavior,
        children: widget.children.map(_buildShimmerPlaceholder).toList(),
      );
    }
    // Padding
    if (widget is Padding) {
      return Padding(
        padding: widget.padding,
        child: _buildShimmerPlaceholder(widget.child!),
      );
    }
    // Expanded
    if (widget is Expanded) {
      return Expanded(
        flex: widget.flex,
        child: _buildShimmerPlaceholder(widget.child),
      );
    }
    // Center
    if (widget is Center) {
      return Center(
        widthFactor: widget.widthFactor,
        heightFactor: widget.heightFactor,
        child: widget.child != null
            ? _buildShimmerPlaceholder(widget.child!)
            : null,
      );
    }
    // Align
    if (widget is Align) {
      return Align(
        alignment: widget.alignment,
        widthFactor: widget.widthFactor,
        heightFactor: widget.heightFactor,
        child: widget.child != null
            ? _buildShimmerPlaceholder(widget.child!)
            : null,
      );
    }
    // ClipRRect
    if (widget is ClipRRect) {
      return ClipRRect(
        borderRadius: widget.borderRadius,
        clipper: widget.clipper,
        clipBehavior: widget.clipBehavior,
        child: widget.child != null
            ? _buildShimmerPlaceholder(widget.child!)
            : null,
      );
    }
    // Card
    if (widget is Card) {
      return Card(
        color: Colors.white,
        elevation: widget.elevation,
        shape: widget.shape,
        margin: widget.margin,
        child: widget.child != null
            ? _buildShimmerPlaceholder(widget.child!)
            : null,
      );
    }
    // Container
    if (widget is Container) {
      if (widget.child != null) {
        return Container(
          margin: widget.margin,
          padding: widget.padding,
          decoration:
              widget.decoration ?? const BoxDecoration(color: Colors.white),
          width: widget.constraints?.maxWidth,
          height: widget.constraints?.maxHeight,
          child: _buildShimmerPlaceholder(widget.child!),
        );
      } else {
        // Empty container -> placeholder box
        return Container(
          margin: widget.margin,
          padding: widget.padding,
          width: widget.constraints?.maxWidth,
          height: widget.constraints?.maxHeight,
          decoration:
              widget.decoration ?? const BoxDecoration(color: Colors.white),
        );
      }
    }
    // SizedBox
    if (widget is SizedBox) {
      if (widget.child != null) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: _buildShimmerPlaceholder(widget.child!),
        );
      }
      return SizedBox(width: widget.width, height: widget.height);
    }

    // Default: return a placeholder container if content is unknown but has size?
    // Or just return the widget and hope for the best (risky but keeps layout).
    // Let's return the widget for now to avoid breaking custom widgets completely.
    return widget;
  }
}
