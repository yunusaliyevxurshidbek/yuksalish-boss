import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../injection_container.dart';
import '../bloc/finance_bloc.dart';
import '../widgets/all_payments_search_filter.dart';
import '../widgets/all_payments_states.dart';
import '../widgets/all_payments_status_chips.dart';
import '../widgets/payment_details_sheet.dart';
import '../widgets/payment_list_item.dart';

/// Screen displaying all payments with search and filter.
class AllPaymentsScreen extends StatelessWidget {
  const AllPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FinanceBloc>()..add(const LoadFinanceData()),
      child: const _AllPaymentsContent(),
    );
  }
}

class _AllPaymentsContent extends StatefulWidget {
  const _AllPaymentsContent();

  @override
  State<_AllPaymentsContent> createState() => _AllPaymentsContentState();
}

class _AllPaymentsContentState extends State<_AllPaymentsContent> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  int _selectedStatusIndex = 0;

  final List<StatusFilter> _statusFilters = const [
    (label: 'finance_all', status: null),
    (label: 'finance_completed', status: PaymentStatus.completed),
    (label: 'finance_expected', status: PaymentStatus.pending),
    (label: 'finance_overdue', status: PaymentStatus.overdue),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<FinanceBloc>().add(const LoadMorePayments());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          AllPaymentsSearchFilter(searchController: _searchController),
          AllPaymentsStatusChips(
            selectedIndex: _selectedStatusIndex,
            onIndexChanged: (index) {
              setState(() {
                _selectedStatusIndex = index;
              });
            },
            statusFilters: _statusFilters,
          ),
          Expanded(
            child: _buildPaymentsList(context),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(
          Icons.arrow_back_rounded,
          size: 20.w,
          color: theme.textTheme.titleMedium?.color,
        ),
      ),
      title: Text(
        'finance_all_payments_title'.tr(),
        style: AppTextStyles.h3.copyWith(
          color: theme.textTheme.titleLarge?.color,
        ),
      ),
    );
  }

  Widget _buildPaymentsList(BuildContext context) {
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        if (state.status == FinanceStatus.loading &&
            state.filteredPayments.isEmpty) {
          return const AllPaymentsLoadingState();
        }

        if (state.status == FinanceStatus.error &&
            state.filteredPayments.isEmpty) {
          return AllPaymentsErrorState(errorMessage: state.errorMessage);
        }

        if (state.filteredPayments.isEmpty) {
          return const AllPaymentsEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<FinanceBloc>().add(const RefreshFinanceData());
          },
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(AppSizes.p16.w),
            itemCount: state.filteredPayments.length +
                (state.isLoadingMorePayments ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.filteredPayments.length) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.p16.w),
                    child: const CircularProgressIndicator(),
                  ),
                );
              }

              final payment = state.filteredPayments[index];
              return PaymentListItem(
                payment: payment,
                onTap: () => PaymentDetailsSheet.show(context, payment),
              );
            },
          ),
        );
      },
    );
  }
}
