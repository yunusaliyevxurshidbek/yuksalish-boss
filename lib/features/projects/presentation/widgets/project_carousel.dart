import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/project.dart';
import 'project_carousel_card.dart';

class ProjectCarousel extends StatefulWidget {
  final List<Project> projects;
  final int? selectedProjectId;
  final Function(int projectId)? onProjectSelected;

  const ProjectCarousel({
    super.key,
    required this.projects,
    this.selectedProjectId,
    this.onProjectSelected,
  });

  @override
  State<ProjectCarousel> createState() => _ProjectCarouselState();
}

class _ProjectCarouselState extends State<ProjectCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _initPageController();
  }

  @override
  void didUpdateWidget(ProjectCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedProjectId != oldWidget.selectedProjectId) {
      _scrollToSelectedProject();
    }
  }

  void _initPageController() {
    // Find the index of selected project
    int initialPage = 0;
    if (widget.selectedProjectId != null) {
      initialPage = widget.projects.indexWhere(
        (p) => p.id == widget.selectedProjectId,
      );
      if (initialPage < 0) initialPage = 0;
    }
    _currentPage = initialPage;
    _pageController = PageController(
      viewportFraction: 0.75,
      initialPage: initialPage,
    );
  }

  void _scrollToSelectedProject() {
    if (widget.selectedProjectId == null) return;
    final index = widget.projects.indexWhere(
      (p) => p.id == widget.selectedProjectId,
    );
    if (index >= 0 && index != _currentPage) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.projects.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        SizedBox(
          height: 200.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.projects.length,
            padEnds: false, // Align first card to left edge instead of centering
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              // Auto-select when swiping
              final project = widget.projects[index];
              if (project.id != widget.selectedProjectId) {
                widget.onProjectSelected?.call(project.id);
              }
            },
            itemBuilder: (context, index) {
              final project = widget.projects[index];
              final isSelected = project.id == widget.selectedProjectId;
              final isFirst = index == 0;
              final isLast = index == widget.projects.length - 1;

              return Padding(
                // Add 16px padding for first/last cards to align with global content padding
                padding: EdgeInsets.only(
                  left: isFirst ? 16.w : 0,
                  right: isLast ? 16.w : 0,
                ),
                child: ProjectCarouselCard(
                  project: project,
                  isSelected: isSelected,
                  onTap: () {
                    widget.onProjectSelected?.call(project.id);
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        // Page indicator
        SmoothPageIndicator(
          controller: _pageController,
          count: widget.projects.length,
          effect: WormEffect(
            dotWidth: 8.w,
            dotHeight: 8.w,
            spacing: 6.w,
            activeDotColor: theme.colorScheme.primary,
            dotColor: theme.colorScheme.primary.withAlpha(50),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      height: 200.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.apartment_outlined,
              size: 48.w,
              color: theme.textTheme.bodySmall?.color,
            ),
            SizedBox(height: 12.h),
            Text(
              'Loyihalar topilmadi',
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectCarouselSkeleton extends StatelessWidget {
  const ProjectCarouselSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      children: [
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 280.w,
                margin: EdgeInsets.only(right: 12.w),
                decoration: BoxDecoration(
                  color: shimmerColor.withAlpha(100),
                  borderRadius: BorderRadius.circular(16.r),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => Container(
              width: 8.w,
              height: 8.w,
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == 0
                    ? theme.colorScheme.primary.withAlpha(100)
                    : shimmerColor.withAlpha(100),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
