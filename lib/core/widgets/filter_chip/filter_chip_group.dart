import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_colors.dart';

/// Horizontal scrollable filter chips for data filtering.
///
/// Displays a row of selectable chips that scroll horizontally.
/// Commonly used for time period selection, status filters, etc.
class FilterChipGroup extends StatelessWidget {
  /// List of filter labels.
  final List<String> items;

  /// Currently selected index.
  final int selectedIndex;

  /// Callback when a chip is selected.
  final ValueChanged<int> onSelected;

  /// Horizontal padding around the group.
  final double horizontalPadding;

  /// Spacing between chips.
  final double spacing;

  /// Whether chips should be equally sized.
  final bool equalWidth;

  /// Custom chip builder for advanced customization.
  final Widget Function(BuildContext, int, bool)? chipBuilder;

  /// Whether to use compact style (smaller chips).
  final bool compact;

  const FilterChipGroup({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.horizontalPadding = 0,
    this.spacing = 10,
    this.equalWidth = false,
    this.chipBuilder,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 40.h : 50.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: spacing.w),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;

          if (chipBuilder != null) {
            return GestureDetector(
              onTap: () => onSelected(index),
              child: chipBuilder!(context, index, isSelected),
            );
          }

          return _AnimatedFilterChip(
            label: items[index],
            isSelected: isSelected,
            onTap: () => onSelected(index),
            compact: compact,
          );
        },
      ),
    );
  }
}

/// Individual filter chip widget with premium styling.
class _AnimatedFilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool compact;

  const _AnimatedFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.compact = false,
  });

  @override
  State<_AnimatedFilterChip> createState() => _AnimatedFilterChipState();
}

class _AnimatedFilterChipState extends State<_AnimatedFilterChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: _FilterChipContent(
          label: widget.label,
          isSelected: widget.isSelected,
          compact: widget.compact,
        ),
      ),
    );
  }
}

class _FilterChipContent extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool compact;

  const _FilterChipContent({
    required this.label,
    required this.isSelected,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSizes.p16.w : AppSizes.p20.w,
        vertical: compact ? AppSizes.p8.h : AppSizes.p12.h,
      ),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor,
                  primaryColor.withValues(
                    blue: (primaryColor.b * 1.15).clamp(0, 1),
                  ),
                ],
              )
            : null,
        color: isSelected ? null : theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(
          color: isSelected
              ? Colors.transparent
              : (isDark ? AppColors.darkBorder : AppColors.border)
                  .withValues(alpha: 0.6),
          width: 1.2,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Text(
        label,
        style: (compact ? AppTextStyles.labelMedium : AppTextStyles.labelLarge)
            .copyWith(
          color: isSelected
              ? theme.colorScheme.onPrimary
              : theme.textTheme.bodyMedium?.color,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
