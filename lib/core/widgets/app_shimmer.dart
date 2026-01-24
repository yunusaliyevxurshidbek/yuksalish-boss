import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_colors.dart';

/// Shimmer loading effect wrapper for skeleton loading states.
///
/// Wraps child widgets with a shimmer animation effect to indicate
/// loading state. Use with placeholder containers that match the
/// expected content layout.
///
/// Example:
/// ```dart
/// AppShimmer(
///   child: Container(
///     width: 100,
///     height: 20,
///     color: Colors.grey,
///   ),
/// )
/// ```
class AppShimmer extends StatelessWidget {
  /// The child widget to apply shimmer effect to
  final Widget child;

  /// Base color for shimmer (darker)
  final Color? baseColor;

  /// Highlight color for shimmer (lighter, moving)
  final Color? highlightColor;

  /// Whether shimmer is enabled (useful for conditional loading)
  final bool enabled;

  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultBaseColor = isDark ? AppColors.darkBorder : AppColors.border;
    final defaultHighlightColor = isDark ? AppColors.darkDivider : AppColors.divider;

    return Shimmer.fromColors(
      baseColor: baseColor ?? defaultBaseColor,
      highlightColor: highlightColor ?? defaultHighlightColor,
      child: child,
    );
  }
}

/// Pre-built shimmer placeholder shapes for common UI elements
class ShimmerPlaceholder extends StatelessWidget {
  /// Width of the placeholder
  final double width;

  /// Height of the placeholder
  final double height;

  /// Border radius
  final double borderRadius;

  /// Whether to use circular shape
  final bool isCircle;

  const ShimmerPlaceholder({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 4,
    this.isCircle = false,
  });

  /// Creates a text line placeholder
  factory ShimmerPlaceholder.text({
    double width = 100,
    double height = 14,
  }) {
    return ShimmerPlaceholder(
      width: width,
      height: height,
      borderRadius: 4,
    );
  }

  /// Creates a circular avatar placeholder
  factory ShimmerPlaceholder.avatar({
    double size = 40,
  }) {
    return ShimmerPlaceholder(
      width: size,
      height: size,
      isCircle: true,
    );
  }

  /// Creates a card placeholder
  factory ShimmerPlaceholder.card({
    double width = double.infinity,
    double height = 120,
    double borderRadius = 12,
  }) {
    return ShimmerPlaceholder(
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final placeholderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: placeholderColor,
        borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
    );
  }
}

/// Shimmer list item placeholder
class ShimmerListItem extends StatelessWidget {
  /// Whether to show leading avatar
  final bool showAvatar;

  /// Number of text lines to show
  final int textLines;

  /// Whether to show trailing element
  final bool showTrailing;

  const ShimmerListItem({
    super.key,
    this.showAvatar = true,
    this.textLines = 2,
    this.showTrailing = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            if (showAvatar) ...[
              const ShimmerPlaceholder(
                width: 48,
                height: 48,
                isCircle: true,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  textLines,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: index < textLines - 1 ? 8 : 0),
                    child: ShimmerPlaceholder(
                      width: index == 0 ? 150 : 100,
                      height: index == 0 ? 16 : 12,
                    ),
                  ),
                ),
              ),
            ),
            if (showTrailing)
              const ShimmerPlaceholder(
                width: 60,
                height: 24,
                borderRadius: 12,
              ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer grid for metric cards
class ShimmerMetricGrid extends StatelessWidget {
  /// Number of items in the grid
  final int itemCount;

  /// Number of columns
  final int crossAxisCount;

  /// Spacing between items
  final double spacing;

  const ShimmerMetricGrid({
    super.key,
    this.itemCount = 4,
    this.crossAxisCount = 2,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1.5,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return AppShimmer(
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerPlaceholder(width: 32, height: 32, borderRadius: 8),
                SizedBox(height: 12),
                ShimmerPlaceholder(width: 80, height: 20),
                SizedBox(height: 4),
                ShimmerPlaceholder(width: 50, height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
