import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';

/// Animated progress bar for funnel stages.
class FunnelProgressBar extends StatelessWidget {
  final Color color;
  final double value;

  const FunnelProgressBar({
    super.key,
    required this.color,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final trackColor = isDark ? AppColors.darkBorder : AppColors.border;

    final clamped = min(max(value, 0.0), 1.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Stack(
            children: [
              Container(
                height: 6.h,
                width: double.infinity,
                color: trackColor,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 6.h,
                width: constraints.maxWidth * clamped,
                color: color,
              ),
            ],
          ),
        );
      },
    );
  }
}
