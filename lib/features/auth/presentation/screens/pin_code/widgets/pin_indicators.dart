import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// PIN code indicator dots.
class PinIndicators extends StatelessWidget {
  final int filledCount;
  final bool hasError;
  final int totalDigits;

  const PinIndicators({
    super.key,
    required this.filledCount,
    this.hasError = false,
    this.totalDigits = 4,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor =
        hasError ? theme.colorScheme.error : theme.colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDigits, (index) {
        final isFilled = index < filledCount;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 16.w,
          height: 16.h,
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? activeColor : Colors.transparent,
            border: Border.all(
              color: activeColor,
              width: 2,
            ),
          ),
        );
      }),
    );
  }
}
