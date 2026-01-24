import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../injection_container.dart';
import '../../data/models/lead_model.dart';
import '../bloc/lead_details_cubit.dart';
import '../bloc/lead_details_state.dart';
import '../widgets/lead_details_header_card.dart';
import '../widgets/lead_details_info_cards.dart';
import '../widgets/lead_details_states.dart';

class LeadDetailsScreen extends StatelessWidget {
  final int leadId;

  const LeadDetailsScreen({super.key, required this.leadId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LeadDetailsCubit>()..loadLead(leadId),
      child: _LeadDetailsView(leadId: leadId),
    );
  }
}

class _LeadDetailsView extends StatelessWidget {
  final int leadId;

  const _LeadDetailsView({required this.leadId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        surfaceTintColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.iconTheme.color),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Lid tafsilotlari',
          style: AppTextStyles.h3.copyWith(
            color: theme.textTheme.titleLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<LeadDetailsCubit, LeadDetailsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const LeadDetailsLoadingView();
          }

          if (state.hasError) {
            return LeadDetailsErrorView(
              message: state.errorMessage ?? 'Xatolik yuz berdi',
              onRetry: () => context.read<LeadDetailsCubit>().loadLead(leadId),
            );
          }

          if (state.lead == null) {
            return const LeadDetailsEmptyView();
          }

          return _LeadContent(lead: state.lead!);
        },
      ),
    );
  }
}

class _LeadContent extends StatelessWidget {
  final Lead lead;

  const _LeadContent({required this.lead});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () => context.read<LeadDetailsCubit>().refresh(lead.id),
      color: theme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSizes.p16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card with Avatar and Basic Info
            LeadDetailsHeaderCard(lead: lead),
            SizedBox(height: AppSizes.p16.h),

            // Details Section
            LeadDetailsContactCard(lead: lead),
            SizedBox(height: AppSizes.p16.h),

            // Notes Section
            if (lead.notes != null && lead.notes!.isNotEmpty) ...[
              LeadDetailsNotesCard(notes: lead.notes!),
              SizedBox(height: AppSizes.p16.h),
            ],

            // Tags Section
            if (lead.tags.isNotEmpty) ...[
              LeadDetailsTagsCard(tags: lead.tags),
              SizedBox(height: AppSizes.p16.h),
            ],

            // Client/MCHJ Info
            if (lead.clientName != null || lead.mchjName != null) ...[
              LeadDetailsLinkedCard(lead: lead),
              SizedBox(height: AppSizes.p16.h),
            ],

            // Timestamps
            LeadDetailsTimestampsCard(lead: lead),
            SizedBox(height: AppSizes.p24.h),
          ],
        ),
      ),
    );
  }
}
