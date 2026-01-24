import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../injection_container.dart';
import '../bloc/approvals_cubit.dart';
import '../widgets/approval_card.dart';
import '../widgets/approval_detail_sheet.dart';
import '../widgets/approval_filter_bar.dart';
import '../widgets/approvals_app_bar.dart';
import '../widgets/approvals_dialogs.dart';
import '../widgets/approvals_states.dart';

class ApprovalsScreen extends StatelessWidget {
  const ApprovalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ApprovalsCubit>()..loadApprovals(),
      child: const _ApprovalsScreenContent(),
    );
  }
}

class _ApprovalsScreenContent extends StatelessWidget {
  const _ApprovalsScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const ApprovalsAppBar(),
      body: BlocConsumer<ApprovalsCubit, ApprovalsState>(
        listener: (context, state) {
          if (state.lastAction != null) {
            ApprovalsDialogs.showActionSnackBar(context, state);
            context.read<ApprovalsCubit>().clearLastAction();
          }
        },
        builder: (context, state) {
          if (state.status == ApprovalsStatus.loading) {
            return const ApprovalsLoadingState();
          }

          if (state.status == ApprovalsStatus.error) {
            return ApprovalsErrorState(errorMessage: state.errorMessage);
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<ApprovalsCubit>().refresh();
            },
            color: theme.colorScheme.primary,
            child: Column(
              children: [
                SizedBox(height: AppSizes.p12.h),
                ApprovalFilterBar(
                  selectedFilter: state.selectedFilter,
                  onFilterChanged: (filter) {
                    context.read<ApprovalsCubit>().filterByType(filter);
                  },
                ),
                SizedBox(height: AppSizes.p12.h),
                ApprovalsPendingCount(count: state.pendingCount),
                SizedBox(height: AppSizes.p12.h),
                Expanded(
                  child: state.filteredApprovals.isEmpty
                      ? const ApprovalsEmptyState()
                      : _buildApprovalsList(context, state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildApprovalsList(BuildContext context, ApprovalsState state) {
    return ListView.builder(
      padding: EdgeInsets.only(
        left: AppSizes.p16.w,
        right: AppSizes.p16.w,
        bottom: 130.h,
      ),
      itemCount: state.filteredApprovals.length,
      itemBuilder: (context, index) {
        final approval = state.filteredApprovals[index];
        return ApprovalCard(
          approval: approval,
          isProcessing: state.isProcessing(approval.id),
          onTap: () => _showDetailSheet(context, approval),
          onApprove: () => ApprovalsDialogs.showApproveDialog(context, approval.id),
          onReject: () => ApprovalsDialogs.showRejectDialog(context, approval.id),
          onComment: () => _showDetailSheet(context, approval),
        );
      },
    );
  }

  void _showDetailSheet(BuildContext context, approval) {
    final cubit = context.read<ApprovalsCubit>();
    ApprovalDetailSheet.show(
      context,
      approval: approval,
      onApprove: () => cubit.approve(approval.id),
      onApproveWithComment: (comment) =>
          cubit.approve(approval.id, comment: comment),
      onRejectWithComment: (comment) => cubit.reject(approval.id, comment),
    );
  }
}
