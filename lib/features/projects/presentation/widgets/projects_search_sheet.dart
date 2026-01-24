import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/models.dart';

class ProjectsSearchSheet extends StatefulWidget {
  final List<Project> projects;
  final List<Apartment> apartments;
  final Function(int projectId) onProjectSelected;
  final Function(int apartmentId) onApartmentSelected;

  const ProjectsSearchSheet({
    super.key,
    required this.projects,
    required this.apartments,
    required this.onProjectSelected,
    required this.onApartmentSelected,
  });

  @override
  State<ProjectsSearchSheet> createState() => _ProjectsSearchSheetState();
}

class _ProjectsSearchSheetState extends State<ProjectsSearchSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final query = _searchController.text.toLowerCase();

    final filteredProjects = query.isEmpty
        ? widget.projects
        : widget.projects.where((project) {
            return project.name.toLowerCase().contains(query) ||
                project.location.toLowerCase().contains(query) ||
                (project.builder?.toLowerCase().contains(query) ?? false);
          }).toList();

    final filteredApartments = query.isEmpty
        ? widget.apartments
        : widget.apartments.where((apartment) {
            return apartment.apartmentNumber.toLowerCase().contains(query) ||
                apartment.block.toLowerCase().contains(query) ||
                apartment.floor.toString().contains(query);
          }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          _buildHandle(borderColor),
          _buildHeader(theme, isDark, borderColor),
          Expanded(
            child: query.isEmpty
                ? _SearchPlaceholder(borderColor: borderColor)
                : _SearchResults(
                    projects: filteredProjects,
                    apartments: filteredApartments,
                    onProjectSelected: widget.onProjectSelected,
                    onApartmentSelected: widget.onApartmentSelected,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle(Color borderColor) {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: borderColor,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark, Color borderColor) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'projects_search_title'.tr(),
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close_rounded,
                  color: theme.textTheme.bodySmall?.color,
                  size: 24.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'projects_search_placeholder'.tr(),
              hintStyle: GoogleFonts.inter(
                fontSize: 14.sp,
                color: theme.textTheme.bodySmall?.color,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: theme.textTheme.bodySmall?.color,
                size: 20.w,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.clear_rounded,
                        color: theme.textTheme.bodySmall?.color,
                        size: 20.w,
                      ),
                    )
                  : null,
              filled: true,
              fillColor: theme.scaffoldBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
            ),
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchPlaceholder extends StatelessWidget {
  final Color borderColor;

  const _SearchPlaceholder({required this.borderColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            size: 64.w,
            color: borderColor,
          ),
          SizedBox(height: 16.h),
          Text(
            'common_start_search'.tr(),
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'projects_search_hint'.tr(),
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List<Project> projects;
  final List<Apartment> apartments;
  final Function(int) onProjectSelected;
  final Function(int) onApartmentSelected;

  const _SearchResults({
    required this.projects,
    required this.apartments,
    required this.onProjectSelected,
    required this.onApartmentSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    if (projects.isEmpty && apartments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64.w,
              color: borderColor,
            ),
            SizedBox(height: 16.h),
            Text(
              'Natija topilmadi',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        if (projects.isNotEmpty) ...[
          _SectionTitle(title: 'projects_section_projects'.tr(), count: projects.length),
          SizedBox(height: 8.h),
          ...projects.map((project) => _ProjectSearchItem(
                project: project,
                onTap: () {
                  Navigator.pop(context);
                  onProjectSelected(project.id);
                },
              )),
          SizedBox(height: 16.h),
        ],
        if (apartments.isNotEmpty) ...[
          _SectionTitle(title: 'projects_section_apartments'.tr(), count: apartments.length),
          SizedBox(height: 8.h),
          ...apartments.map((apartment) => _ApartmentSearchItem(
                apartment: apartment,
                onTap: () {
                  Navigator.pop(context);
                  onApartmentSelected(apartment.id);
                },
              )),
        ],
        SizedBox(height: 24.h),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final int count;

  const _SectionTitle({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            '$count',
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProjectSearchItem extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const _ProjectSearchItem({required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor.withAlpha(100)),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.apartment_rounded,
                color: theme.colorScheme.primary,
                size: 24.w,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.titleMedium?.color,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    project.location,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.w,
              color: theme.textTheme.bodySmall?.color,
            ),
          ],
        ),
      ),
    );
  }
}

class _ApartmentSearchItem extends StatelessWidget {
  final Apartment apartment;
  final VoidCallback onTap;

  const _ApartmentSearchItem({required this.apartment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor.withAlpha(100)),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: apartment.status.color.withAlpha(30),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  apartment.apartmentNumber,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: apartment.status.color,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Blok ${apartment.block}, Qavat ${apartment.floor}',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.titleMedium?.color,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${apartment.rooms}-xona • ${apartment.area} m²',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: apartment.status.color.withAlpha(20),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                apartment.status.displayName,
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: apartment.status.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
