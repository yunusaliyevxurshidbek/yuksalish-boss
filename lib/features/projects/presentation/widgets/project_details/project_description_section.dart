import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'project_details_colors.dart';

/// Expandable description section for project details.
class ProjectDescriptionSection extends StatefulWidget {
  final String description;

  const ProjectDescriptionSection({
    super.key,
    required this.description,
  });

  @override
  State<ProjectDescriptionSection> createState() =>
      _ProjectDescriptionSectionState();
}

class _ProjectDescriptionSectionState extends State<ProjectDescriptionSection> {
  bool _isExpanded = false;
  static const int _maxLines = 3;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ProjectDetailsColors.cardWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'projects_about'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: ProjectDetailsColors.textDark,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 12.h),
          AnimatedCrossFade(
            firstChild: Text(
              widget.description,
              maxLines: _maxLines,
              overflow: TextOverflow.ellipsis,
              style: _descriptionStyle,
            ),
            secondChild: Text(
              widget.description,
              style: _descriptionStyle,
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              children: [
                Text(
                  _isExpanded ? 'projects_read_less'.tr() : 'projects_read_more'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ProjectDetailsColors.primaryBlue,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: ProjectDetailsColors.primaryBlue,
                  size: 20.w,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle get _descriptionStyle => TextStyle(
        fontSize: 14.sp,
        color: ProjectDetailsColors.textSecondary,
        height: 1.6,
        fontFamily: 'Inter',
      );
}
