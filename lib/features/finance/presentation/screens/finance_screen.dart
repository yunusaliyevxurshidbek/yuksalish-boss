import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../injection_container.dart';
import '../../../../presentation/widgets/custom_snacbar.dart';
import '../bloc/finance_bloc.dart';
import '../widgets/debts_tab.dart';
import '../widgets/finance_screen_widgets.dart';
import '../widgets/payments_tab.dart';
import '../widgets/record_payment_modal.dart';

/// Finance screen with two tabs: To'lovlar and Qarzdorliklar
class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FinanceBloc>()..add(const LoadFinanceData()),
      child: const _FinanceScreenContent(),
    );
  }
}

class _FinanceScreenContent extends StatefulWidget {
  const _FinanceScreenContent();

  @override
  State<_FinanceScreenContent> createState() => _FinanceScreenContentState();
}

class _FinanceScreenContentState extends State<_FinanceScreenContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      context.read<FinanceBloc>().add(ChangeFinanceTab(_tabController.index));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<FinanceBloc, FinanceState>(
      listenWhen: (previous, current) =>
          previous.successMessage != current.successMessage ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.successMessage != null) {
          _showSuccessSnackBar(context, state.successMessage!);
          context.read<FinanceBloc>().add(const ClearMessages());
        }
        if (state.errorMessage != null && state.status != FinanceStatus.error) {
          _showErrorSnackBar(context, state.errorMessage!);
          context.read<FinanceBloc>().add(const ClearMessages());
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'finance_title'.tr(),
            style: AppTextStyles.h3.copyWith(
              color: theme.appBarTheme.foregroundColor ??
                  theme.colorScheme.onPrimary,
            ),
          ),
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 0,
          centerTitle: false,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.h),
            child: FinanceTabBar(tabController: _tabController),
          ),
        ),
        body: BlocBuilder<FinanceBloc, FinanceState>(
          builder: (context, state) {
            if (state.status == FinanceStatus.loading &&
                state.payments.isEmpty &&
                state.debts.isEmpty) {
              return const FinanceLoadingState();
            }

            if (state.status == FinanceStatus.error &&
                state.payments.isEmpty &&
                state.debts.isEmpty) {
              return FinanceErrorState(errorMessage: state.errorMessage);
            }

            return TabBarView(
              controller: _tabController,
              children: const [
                PaymentsTab(),
                DebtsTab(),
              ],
            );
          },
        ),
        floatingActionButton: _buildFab(context),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        return FloatingActionButton.extended(
          onPressed: state.isRecordingPayment
              ? null
              : () => _showRecordPaymentModal(context),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          icon: state.isRecordingPayment
              ? SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : Icon(Icons.add_rounded, size: 20.w),
          label: Text(
            state.isRecordingPayment ? 'finance_saving'.tr() : 'finance_record_payment'.tr(),
            style: AppTextStyles.labelMedium.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }

  void _showRecordPaymentModal(BuildContext context) {
    final bloc = context.read<FinanceBloc>();
    RecordPaymentModal.show(
      context,
      isLoading: bloc.state.isRecordingPayment,
      onSubmit: (request) {
        bloc.add(RecordPayment(request));
        context.pop();
      },
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    CustomSnacbar.show(
      context,
      text: message,
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    CustomSnacbar.show(
      context,
      text: message,
      isError: true,
    );
  }
}
