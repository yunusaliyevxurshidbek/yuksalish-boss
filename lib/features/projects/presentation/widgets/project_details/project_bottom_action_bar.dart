import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'project_details_colors.dart';

/// Bottom action bar with call center and primary CTA buttons.
class ProjectBottomActionBar extends StatelessWidget {
  final VoidCallback? onCallCenterTap;
  final VoidCallback? onSelectApartmentTap;

  const ProjectBottomActionBar({
    super.key,
    this.onCallCenterTap,
    this.onSelectApartmentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        decoration: BoxDecoration(
          color: ProjectDetailsColors.cardWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              _CallCenterButton(onTap: onCallCenterTap),
              SizedBox(width: 12.w),
              Expanded(
                child: _PrimaryButton(onTap: onSelectApartmentTap),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CallCenterButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _CallCenterButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: ProjectDetailsColors.primaryBlue,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.phone_outlined,
                  color: ProjectDetailsColors.primaryBlue,
                  size: 20.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Call Center',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ProjectDetailsColors.primaryBlue,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _PrimaryButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      decoration: BoxDecoration(
        color: ProjectDetailsColors.primaryBlue,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: ProjectDetailsColors.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Center(
            child: Text(
              'Kvartira tanlash',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
