import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../bloc/bloc.dart';
import '../widgets.dart';
import 'dropdown_filter.dart';

/// Apartments tab content for project detail screen.
class ProjectDetailApartmentsTab extends StatelessWidget {
  const ProjectDetailApartmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (context, state) {
        return Column(
          children: [
            _ApartmentFilters(state: state),
            Expanded(
              child: state.isLoadingApartments
                  ? const _ApartmentsLoading()
                  : state.apartments.isEmpty
                      ? const _NoApartments()
                      : ListView.separated(
                          padding: EdgeInsets.all(AppSizes.p16.w),
                          itemCount: state.apartments.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(height: AppSizes.p8.h),
                          itemBuilder: (context, index) {
                            return ApartmentListItem(
                              apartment: state.apartments[index],
                            );
                          },
                        ),
            ),
          ],
        );
      },
    );
  }
}

class _ApartmentFilters extends StatelessWidget {
  final ProjectsState state;

  const _ApartmentFilters({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.p16.w),
      color: theme.cardColor,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownFilter<String?>(
                  value: state.apartmentStatusFilter,
                  hint: 'projects_apartments_filter_status'.tr(),
                  items: [
                    DropdownMenuItem(value: null, child: Text('projects_apartments_all'.tr())),
                    ...ApartmentStatus.values.map(
                      (s) => DropdownMenuItem(
                        value: s.apiValue,
                        child: Text(s.displayName),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (state.selectedProject != null) {
                      context.read<ProjectsBloc>().add(
                            LoadApartments(
                              projectId: state.selectedProject!.id,
                              statusFilter: value,
                              roomsFilter: state.apartmentRoomsFilter,
                            ),
                          );
                    }
                  },
                ),
              ),
              SizedBox(width: AppSizes.p12.w),
              Expanded(
                child: DropdownFilter<int?>(
                  value: state.apartmentRoomsFilter,
                  hint: 'projects_apartments_filter_rooms'.tr(),
                  items: [
                    DropdownMenuItem(value: null, child: Text('projects_apartments_all'.tr())),
                    DropdownMenuItem(value: 1, child: Text('projects_apartments_rooms_1'.tr())),
                    DropdownMenuItem(value: 2, child: Text('projects_apartments_rooms_2'.tr())),
                    DropdownMenuItem(value: 3, child: Text('projects_apartments_rooms_3'.tr())),
                    DropdownMenuItem(value: 4, child: Text('projects_apartments_rooms_4'.tr())),
                  ],
                  onChanged: (value) {
                    if (state.selectedProject != null) {
                      context.read<ProjectsBloc>().add(
                            LoadApartments(
                              projectId: state.selectedProject!.id,
                              statusFilter: state.apartmentStatusFilter,
                              roomsFilter: value,
                            ),
                          );
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.p8.h),
          Text(
            'projects_apartments_found'.tr(args: ['${state.apartments.length}']),
            style: AppTextStyles.caption.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ApartmentsLoading extends StatelessWidget {
  const _ApartmentsLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(AppSizes.p16.w),
      itemCount: 5,
      separatorBuilder: (_, __) => SizedBox(height: AppSizes.p8.h),
      itemBuilder: (context, index) {
        return AppShimmer(
          child: Container(
            height: 80.h,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
            ),
          ),
        );
      },
    );
  }
}

class _NoApartments extends StatelessWidget {
  const _NoApartments();

  @override
  Widget build(BuildContext context) {
    return EmptyState.noData(
      title: 'projects_apartments_not_found'.tr(),
      description: 'projects_apartments_no_match'.tr(),
    );
  }
}
