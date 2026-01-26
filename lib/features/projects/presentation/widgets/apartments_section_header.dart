import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/apartment.dart';

class ApartmentsSectionHeader extends StatelessWidget {
  final String projectName;
  final int apartmentsCount;
  final String? selectedStatus;
  final int? selectedRooms;
  final bool isGridView;
  final bool showMapView;
  final bool hasCoordinates;
  final Function(String?)? onStatusChanged;
  final Function(int?)? onRoomsChanged;
  final VoidCallback? onToggleView;
  final VoidCallback? onToggleMap;

  const ApartmentsSectionHeader({
    super.key,
    required this.projectName,
    required this.apartmentsCount,
    this.selectedStatus,
    this.selectedRooms,
    this.isGridView = false,
    this.showMapView = false,
    this.hasCoordinates = false,
    this.onStatusChanged,
    this.onRoomsChanged,
    this.onToggleView,
    this.onToggleMap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row
        Row(
          children: [
            Expanded(
              child: Text(
                projectName,
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.titleLarge?.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'projects_apartments_count'.tr(namedArgs: {'count': '$apartmentsCount'}),
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        // Status filter
        _buildStatusDropdown(context),
        SizedBox(height: 12.h),
        // Rooms filter
        _buildRoomsFilter(context),
        SizedBox(height: 12.h),
        // Action buttons
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildStatusDropdown(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Row(
      children: [
        Text(
          'projects_status_label'.tr(),
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.bodySmall?.color,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: borderColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedStatus,
                isExpanded: true,
                dropdownColor: theme.cardColor,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: theme.textTheme.bodySmall?.color,
                ),
                hint: Text(
                  'projects_status_all_statuses'.tr(),
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: theme.textTheme.titleMedium?.color,
                ),
                items: [
                  _buildDropdownItem(null, 'projects_status_all'.tr()),
                  _buildDropdownItem(
                      ApartmentStatus.available.apiValue, 'projects_units_empty'.tr()),
                  _buildDropdownItem(ApartmentStatus.reserved.apiValue, 'projects_units_reserved'.tr()),
                  _buildDropdownItem(
                      ApartmentStatus.sold.apiValue, 'projects_units_sold'.tr()),
                ],
                onChanged: onStatusChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(String? value, String label) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(label),
    );
  }

  Widget _buildRoomsFilter(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          'projects_rooms_label'.tr(),
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.bodySmall?.color,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildRoomChip(context, null, 'projects_rooms_all'.tr()),
                SizedBox(width: 8.w),
                _buildRoomChip(context, 1, '1'),
                SizedBox(width: 8.w),
                _buildRoomChip(context, 2, '2'),
                SizedBox(width: 8.w),
                _buildRoomChip(context, 3, '3'),
                SizedBox(width: 8.w),
                _buildRoomChip(context, 4, '4+'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoomChip(BuildContext context, int? value, String label) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final isSelected = selectedRooms == value;

    return GestureDetector(
      onTap: () => onRoomsChanged?.call(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.cardColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : borderColor,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : theme.textTheme.titleMedium?.color,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Map toggle
        if (hasCoordinates) ...[
          _buildActionButton(
            context,
            icon: showMapView ? Icons.map : Icons.map_outlined,
            isActive: showMapView,
            onTap: onToggleMap,
          ),
          SizedBox(width: 8.w),
        ],
        const Spacer(),
        // View toggle
        _buildViewToggle(context),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary.withAlpha(20) : theme.cardColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isActive ? theme.colorScheme.primary : borderColor,
          ),
        ),
        child: Icon(
          icon,
          size: 20.w,
          color: isActive ? theme.colorScheme.primary : theme.textTheme.bodySmall?.color,
        ),
      ),
    );
  }

  Widget _buildViewToggle(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          _buildViewOption(
            context,
            icon: Icons.view_list_rounded,
            isActive: !isGridView,
            onTap: !isGridView ? null : onToggleView,
          ),
          _buildViewOption(
            context,
            icon: Icons.grid_view_rounded,
            isActive: isGridView,
            onTap: isGridView ? null : onToggleView,
          ),
        ],
      ),
    );
  }

  Widget _buildViewOption(
    BuildContext context, {
    required IconData icon,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          icon,
          size: 18.w,
          color: isActive ? Colors.white : theme.textTheme.bodySmall?.color,
        ),
      ),
    );
  }
}
