import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/debt.dart';
import '../models/debt_filter_params.dart';
import '../models/debt_stats.dart';
import '../models/payment.dart';
import '../models/payment_filter_params.dart';
import '../models/payment_stats.dart';
import '../models/record_payment_request.dart';
import '../models/send_sms_request.dart';

/// Abstract class for finance remote data source
abstract class FinanceRemoteDataSource {
  /// Get payment statistics
  Future<PaymentStats> getPaymentStats();

  /// Get paginated list of payments
  Future<PaymentsPaginatedResponse> getPayments({
    PaymentFilterParams? filters,
    int page = 1,
  });

  /// Get overdue payments
  Future<List<Payment>> getOverduePayments();

  /// Get pending payments
  Future<List<Payment>> getPendingPayments();

  /// Get payment by ID
  Future<Payment> getPaymentById(int id);

  /// Record a new payment
  Future<Payment> recordPayment(RecordPaymentRequest request);

  /// Download payment receipt
  Future<String> downloadReceipt(int paymentId);

  /// Export payments to XLSX
  Future<String> exportPayments(PaymentFilterParams? filters);

  /// Get debt statistics
  Future<DebtStats> getDebtStats();

  /// Get paginated list of debts (contracts with remaining amounts)
  Future<DebtsPaginatedResponse> getDebts({
    DebtFilterParams? filters,
    int page = 1,
  });

  /// Get debt detail by contract ID
  Future<Debt> getDebtById(int contractId);

  /// Send SMS reminder to debtor
  Future<void> sendDebtReminder(SendSmsRequest request);

  /// Export debts to XLSX
  Future<String> exportDebts(DebtFilterParams? filters);
}

/// Implementation of FinanceRemoteDataSource
class FinanceRemoteDataSourceImpl implements FinanceRemoteDataSource {
  final Dio _dio;

  FinanceRemoteDataSourceImpl(this._dio);

  @override
  Future<PaymentStats> getPaymentStats() async {
    try {
      final response = await _dio.get('crm/payments/stats/');

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return PaymentStats.fromJson(data);
      }

      throw ServerExceptions(
        message: 'Unexpected response format.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      // If stats endpoint doesn't exist (404), compute from payments list
      if (e.response?.statusCode == 404) {
        return _computePaymentStatsFromList();
      }
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Compute payment stats from the payments list when stats endpoint is unavailable
  Future<PaymentStats> _computePaymentStatsFromList() async {
    try {
      // Fetch all payments (we may need to paginate for large datasets)
      final response = await _dio.get('crm/payments/', queryParameters: {'page_size': 1000});

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        return PaymentStats.empty();
      }

      final paymentsResponse = PaymentsPaginatedResponse.fromJson(data);
      final payments = paymentsResponse.results;

      if (payments.isEmpty) {
        return PaymentStats.empty();
      }

      final now = DateTime.now();
      final thisMonth = DateTime(now.year, now.month, 1);

      double totalReceived = 0;
      int receivedThisMonth = 0;
      double pendingPayments = 0;
      int pendingCount = 0;
      double overduePayments = 0;
      int overdueCount = 0;

      int completedCount = 0;

      for (final payment in payments) {
        switch (payment.status) {
          case PaymentStatus.completed:
            totalReceived += payment.amount;
            completedCount++;
            if (payment.date.isAfter(thisMonth) || payment.date.isAtSameMomentAs(thisMonth)) {
              receivedThisMonth++;
            }
          case PaymentStatus.pending:
            pendingPayments += payment.amount;
            pendingCount++;
          case PaymentStatus.overdue:
            overduePayments += payment.amount;
            overdueCount++;
          case PaymentStatus.cancelled:
            // Skip cancelled payments
            break;
        }
      }

      // Calculate percentages for the donut chart
      final totalCount = completedCount + pendingCount + overdueCount;
      final paidPercentage = totalCount > 0 ? (completedCount / totalCount) * 100 : 0.0;
      final pendingPercentage = totalCount > 0 ? (pendingCount / totalCount) * 100 : 0.0;
      final noInitialPercentage = totalCount > 0 ? (overdueCount / totalCount) * 100 : 0.0;

      return PaymentStats(
        totalReceived: totalReceived,
        receivedThisMonth: receivedThisMonth,
        pendingPayments: pendingPayments,
        pendingCount: pendingCount,
        overduePayments: overduePayments,
        overdueCount: overdueCount,
        totalTransactions: paymentsResponse.count,
        paidPercentage: paidPercentage,
        pendingPercentage: pendingPercentage,
        noInitialPercentage: noInitialPercentage,
      );
    } catch (e) {
      // If fetching list also fails, return empty stats
      return PaymentStats.empty();
    }
  }

  @override
  Future<PaymentsPaginatedResponse> getPayments({
    PaymentFilterParams? filters,
    int page = 1,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        ...?filters?.toQueryParams(),
      };

      final response = await _dio.get(
        'crm/payments/',
        queryParameters: queryParams,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return PaymentsPaginatedResponse.fromJson(data);
      }

      throw ServerExceptions(
        message: 'Unexpected response format.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<Payment>> getOverduePayments() async {
    try {
      final response = await _dio.get('crm/payments/overdue/');

      final data = response.data;
      if (data is Map<String, dynamic> && data['results'] is List) {
        return (data['results'] as List)
            .map((e) => Payment.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      if (data is List) {
        return data
            .map((e) => Payment.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw ServerExceptions(
        message: 'Unexpected response format.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<Payment>> getPendingPayments() async {
    try {
      final response = await _dio.get('crm/payments/pending/');

      final data = response.data;
      if (data is Map<String, dynamic> && data['results'] is List) {
        return (data['results'] as List)
            .map((e) => Payment.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      if (data is List) {
        return data
            .map((e) => Payment.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw ServerExceptions(
        message: 'Unexpected response format.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<Payment> getPaymentById(int id) async {
    try {
      final response = await _dio.get('crm/payments/$id/');

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return Payment.fromJson(data);
      }

      throw ServerExceptions(
        message: 'Unexpected response format.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<Payment> recordPayment(RecordPaymentRequest request) async {
    try {
      final response = await _dio.post(
        'crm/payments/',
        data: request.toJson(),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return Payment.fromJson(data);
      }

      throw ServerExceptions(
        message: 'Unexpected response format.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<String> downloadReceipt(int paymentId) async {
    try {
      final response = await _dio.get(
        'crm/payments/$paymentId/download_receipt/',
        options: Options(responseType: ResponseType.bytes),
      );

      // Return the URL or file path for the receipt
      if (response.headers['content-disposition'] != null) {
        return response.headers['content-disposition']!.first;
      }

      return 'receipt_$paymentId.pdf';
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<String> exportPayments(PaymentFilterParams? filters) async {
    try {
      final queryParams = filters?.toQueryParams() ?? <String, dynamic>{};

      final response = await _dio.get(
        'crm/payments/export/',
        queryParameters: queryParams,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.headers['content-disposition'] != null) {
        return response.headers['content-disposition']!.first;
      }

      return 'payments_export.xlsx';
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<DebtStats> getDebtStats() async {
    try {
      // Try dedicated debt stats endpoint first
      final response = await _dio.get('crm/contracts/stats/');

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return DebtStats.fromJson(data);
      }

      throw ServerExceptions(
        message: 'Unexpected response format.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      // If stats endpoint doesn't exist (404), compute from debts list
      if (e.response?.statusCode == 404) {
        return _computeDebtStatsFromList();
      }
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Compute debt stats from the contracts list when stats endpoint is unavailable
  Future<DebtStats> _computeDebtStatsFromList() async {
    try {
      // Fetch all contracts with debt
      final response = await _dio.get(
        'crm/contracts/',
        queryParameters: {'page_size': 1000, 'has_debt': true},
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        return DebtStats.empty();
      }

      final debtsResponse = DebtsPaginatedResponse.fromJson(data);
      final debts = debtsResponse.results;

      if (debts.isEmpty) {
        return DebtStats.empty();
      }

      double totalDebt = 0;
      double overdueAmount = 0;
      int overdueCount = 0;
      int activeCount = 0;

      for (final debt in debts) {
        totalDebt += debt.remainingAmount;
        if (debt.status == DebtStatus.overdue || debt.overdueAmount > 0) {
          overdueAmount += debt.overdueAmount;
          overdueCount++;
        }
        if (debt.status == DebtStatus.active) {
          activeCount++;
        }
      }

      // For paidThisMonth, we need payment data which we don't have here
      // This would require an additional API call to payments
      // For now, we'll leave it as 0 or fetch payments separately
      double paidThisMonth = 0;
      try {
        final now = DateTime.now();
        final startOfMonth = DateTime(now.year, now.month, 1);
        final paymentsResponse = await _dio.get(
          'crm/payments/',
          queryParameters: {
            'page_size': 1000,
            'payment_date_after': startOfMonth.toIso8601String().split('T').first,
          },
        );
        if (paymentsResponse.data is Map<String, dynamic>) {
          final payments = PaymentsPaginatedResponse.fromJson(
            paymentsResponse.data as Map<String, dynamic>,
          );
          for (final payment in payments.results) {
            if (payment.status == PaymentStatus.completed) {
              paidThisMonth += payment.amount;
            }
          }
        }
      } catch (_) {
        // Ignore errors when fetching payments for this stat
      }

      return DebtStats(
        totalDebt: totalDebt,
        overdueAmount: overdueAmount,
        paidThisMonth: paidThisMonth,
        debtorsCount: debtsResponse.count,
        overdueCount: overdueCount,
        activeCount: activeCount,
      );
    } catch (e) {
      // If fetching list also fails, return empty stats
      return DebtStats.empty();
    }
  }

  @override
  Future<DebtsPaginatedResponse> getDebts({
    DebtFilterParams? filters,
    int page = 1,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        // Only get contracts with remaining amount (debts)
        'has_debt': true,
        ...?filters?.toQueryParams(),
      };

      final response = await _dio.get(
        'crm/contracts/',
        queryParameters: queryParams,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return DebtsPaginatedResponse.fromJson(data);
      }

      throw ServerExceptions(
        message: 'Unexpected response format.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<Debt> getDebtById(int contractId) async {
    try {
      final response = await _dio.get('crm/contracts/$contractId/');

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return Debt.fromJson(data);
      }

      throw ServerExceptions(
        message: 'Unexpected response format.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> sendDebtReminder(SendSmsRequest request) async {
    try {
      await _dio.post(
        'crm/sms/send/',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<String> exportDebts(DebtFilterParams? filters) async {
    try {
      final queryParams = filters?.toQueryParams() ?? <String, dynamic>{};

      final response = await _dio.get(
        'crm/contracts/debts/export/',
        queryParameters: queryParams,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.headers['content-disposition'] != null) {
        return response.headers['content-disposition']!.first;
      }

      return 'debts_export.xlsx';
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
      final detail = data['detail'];
      if (detail is String && detail.isNotEmpty) {
        return detail;
      }
      final errors = data['errors'];
      final errorMessage = _firstErrorFrom(errors);
      if (errorMessage != null) {
        return errorMessage;
      }
    }
    if (data is List) {
      final errorMessage = _firstErrorFrom(data);
      if (errorMessage != null) {
        return errorMessage;
      }
    }
    return 'Xatolik yuz berdi. Iltimos, qayta urinib ko\'ring.';
  }

  String? _firstErrorFrom(dynamic errors) {
    if (errors is List && errors.isNotEmpty) {
      final first = errors.first;
      if (first is String && first.isNotEmpty) {
        return first;
      }
    }
    if (errors is Map) {
      for (final value in errors.values) {
        if (value is List && value.isNotEmpty) {
          final first = value.first;
          if (first is String && first.isNotEmpty) {
            return first;
          }
        } else if (value is String && value.isNotEmpty) {
          return value;
        }
      }
    }
    return null;
  }
}
