import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_text_styles.dart';

/// Profile avatar widget with initials fallback.
class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double size;
  final bool showCameraButton;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    required this.initials,
    this.size = 80,
    this.showCameraButton = false,
  });

  /// Check if URL is valid (not null and not empty).
  bool get _hasValidImageUrl => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: primaryColor.withValues(alpha: 0.15),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.3),
          width: 2,
        ),
        image: _hasValidImageUrl
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: !_hasValidImageUrl
          ? Center(
              child: Text(
                initials,
                style: AppTextStyles.h2.copyWith(
                  color: primaryColor,
                  fontSize: (size / 2.5).sp,
                ),
              ),
            )
          : null,
    );
  }
}
