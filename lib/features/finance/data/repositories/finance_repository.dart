import '../datasources/finance_remote_datasource.dart';
import '../models/debt.dart';
import '../models/debt_filter_params.dart';
import '../models/debt_stats.dart';
import '../models/payment.dart';
import '../models/payment_filter_params.dart';
import '../models/payment_stats.dart';
import '../models/record_payment_request.dart';
import '../models/send_sms_request.dart';

/// Abstract finance repository
abstract class FinanceRepository {
  // Payment methods
  Future<PaymentStats> getPaymentStats();
  Future<PaymentsPaginatedResponse> getPayments({
    PaymentFilterParams? filters,
    int page = 1,
  });
  Future<List<Payment>> getOverduePayments();
  Future<List<Payment>> getPendingPayments();
  Future<Payment> getPaymentById(int id);
  Future<Payment> recordPayment(RecordPaymentRequest request);
  Future<String> downloadReceipt(int paymentId);
  Future<String> exportPayments(PaymentFilterParams? filters);

  // Debt methods
  Future<DebtStats> getDebtStats();
  Future<DebtsPaginatedResponse> getDebts({
    DebtFilterParams? filters,
    int page = 1,
  });
  Future<Debt> getDebtById(int contractId);
  Future<void> sendDebtReminder(SendSmsRequest request);
  Future<String> exportDebts(DebtFilterParams? filters);
}

/// Implementation of FinanceRepository using remote data source
class FinanceRepositoryImpl implements FinanceRepository {
  final FinanceRemoteDataSource _remoteDataSource;

  FinanceRepositoryImpl(this._remoteDataSource);

  @override
  Future<PaymentStats> getPaymentStats() {
    return _remoteDataSource.getPaymentStats();
  }

  @override
  Future<PaymentsPaginatedResponse> getPayments({
    PaymentFilterParams? filters,
    int page = 1,
  }) {
    return _remoteDataSource.getPayments(filters: filters, page: page);
  }

  @override
  Future<List<Payment>> getOverduePayments() {
    return _remoteDataSource.getOverduePayments();
  }

  @override
  Future<List<Payment>> getPendingPayments() {
    return _remoteDataSource.getPendingPayments();
  }

  @override
  Future<Payment> getPaymentById(int id) {
    return _remoteDataSource.getPaymentById(id);
  }

  @override
  Future<Payment> recordPayment(RecordPaymentRequest request) {
    return _remoteDataSource.recordPayment(request);
  }

  @override
  Future<String> downloadReceipt(int paymentId) {
    return _remoteDataSource.downloadReceipt(paymentId);
  }

  @override
  Future<String> exportPayments(PaymentFilterParams? filters) {
    return _remoteDataSource.exportPayments(filters);
  }

  @override
  Future<DebtStats> getDebtStats() {
    return _remoteDataSource.getDebtStats();
  }

  @override
  Future<DebtsPaginatedResponse> getDebts({
    DebtFilterParams? filters,
    int page = 1,
  }) {
    return _remoteDataSource.getDebts(filters: filters, page: page);
  }

  @override
  Future<Debt> getDebtById(int contractId) {
    return _remoteDataSource.getDebtById(contractId);
  }

  @override
  Future<void> sendDebtReminder(SendSmsRequest request) {
    return _remoteDataSource.sendDebtReminder(request);
  }

  @override
  Future<String> exportDebts(DebtFilterParams? filters) {
    return _remoteDataSource.exportDebts(filters);
  }
}

/// Mock implementation of FinanceRepository for development/testing
class FinanceRepositoryMock implements FinanceRepository {
  @override
  Future<PaymentStats> getPaymentStats() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const PaymentStats(
      totalReceived: 1200000000,
      receivedThisMonth: 23,
      pendingPayments: 890000000,
      pendingCount: 45,
      overduePayments: 156000000,
      overdueCount: 8,
      totalTransactions: 312,
      paidPercentage: 65,
      pendingPercentage: 23,
      noInitialPercentage: 12,
    );
  }

  @override
  Future<PaymentsPaginatedResponse> getPayments({
    PaymentFilterParams? filters,
    int page = 1,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return PaymentsPaginatedResponse(
      count: _mockPayments.length,
      results: _mockPayments,
    );
  }

  @override
  Future<List<Payment>> getOverduePayments() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockPayments
        .where((p) => p.status == PaymentStatus.overdue)
        .toList();
  }

  @override
  Future<List<Payment>> getPendingPayments() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockPayments
        .where((p) => p.status == PaymentStatus.pending)
        .toList();
  }

  @override
  Future<Payment> getPaymentById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockPayments.firstWhere(
      (p) => p.id == id.toString(),
      orElse: () => _mockPayments.first,
    );
  }

  @override
  Future<Payment> recordPayment(RecordPaymentRequest request) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return Payment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      receiptNumber: 'KV-${DateTime.now().millisecondsSinceEpoch}',
      clientId: 1,
      clientName: 'Test Client',
      contractId: request.contractId,
      contractNumber: 'SH-${request.contractId}',
      amount: request.amount,
      currency: request.currency,
      type: request.method,
      date: request.paymentDate,
      status: PaymentStatus.completed,
      processedBy: 'Admin',
    );
  }

  @override
  Future<String> downloadReceipt(int paymentId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'receipt_$paymentId.pdf';
  }

  @override
  Future<String> exportPayments(PaymentFilterParams? filters) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return 'payments_export.xlsx';
  }

  @override
  Future<DebtStats> getDebtStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const DebtStats(
      totalDebt: 2400000000,
      overdueAmount: 450000000,
      paidThisMonth: 320000000,
      debtorsCount: 34,
      overdueCount: 12,
      activeCount: 22,
    );
  }

  @override
  Future<DebtsPaginatedResponse> getDebts({
    DebtFilterParams? filters,
    int page = 1,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return DebtsPaginatedResponse(
      count: _mockDebts.length,
      results: _mockDebts,
    );
  }

  @override
  Future<Debt> getDebtById(int contractId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockDebts.firstWhere(
      (d) => d.contractId == contractId,
      orElse: () => _mockDebts.first,
    );
  }

  @override
  Future<void> sendDebtReminder(SendSmsRequest request) async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Future<String> exportDebts(DebtFilterParams? filters) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return 'debts_export.xlsx';
  }

  /// Mock payments data
  static final List<Payment> _mockPayments = [
    Payment(
      id: '1',
      receiptNumber: 'KV-2341',
      clientId: 1,
      clientName: 'Alisher Karimov',
      contractId: 4521,
      contractNumber: 'SH-4521',
      amount: 50000000,
      currency: 'UZS',
      type: PaymentType.card,
      date: DateTime(2025, 1, 15),
      status: PaymentStatus.completed,
      projectName: 'Yuksalish Tower',
      processedBy: 'Admin',
    ),
    Payment(
      id: '2',
      receiptNumber: 'KV-2340',
      clientId: 2,
      clientName: 'Nodira Saidova',
      contractId: 4518,
      contractNumber: 'SH-4518',
      amount: 120000000,
      currency: 'UZS',
      type: PaymentType.transfer,
      date: DateTime(2025, 1, 14),
      status: PaymentStatus.pending,
      projectName: 'Green Park Residence',
      processedBy: 'Manager',
    ),
    Payment(
      id: '3',
      receiptNumber: 'KV-2339',
      clientId: 3,
      clientName: 'Jasur Aliyev',
      contractId: 4512,
      contractNumber: 'SH-4512',
      amount: 85000000,
      currency: 'UZS',
      type: PaymentType.cash,
      date: DateTime(2025, 1, 13),
      status: PaymentStatus.completed,
      projectName: 'Yuksalish Tower',
      processedBy: 'Admin',
    ),
    Payment(
      id: '4',
      receiptNumber: 'KV-2338',
      clientId: 4,
      clientName: 'Malika Rahimova',
      contractId: 4508,
      contractNumber: 'SH-4508',
      amount: 200000000,
      currency: 'UZS',
      type: PaymentType.transfer,
      date: DateTime(2025, 1, 12),
      status: PaymentStatus.completed,
      projectName: 'Central Business Hub',
      processedBy: 'Admin',
    ),
    Payment(
      id: '5',
      receiptNumber: 'KV-2337',
      clientId: 5,
      clientName: 'Sherzod Qodirov',
      contractId: 4505,
      contractNumber: 'SH-4505',
      amount: 45000000,
      currency: 'UZS',
      type: PaymentType.card,
      date: DateTime(2025, 1, 11),
      status: PaymentStatus.overdue,
      projectName: 'Green Park Residence',
      processedBy: 'Manager',
    ),
  ];

  /// Mock debts data
  static final List<Debt> _mockDebts = [
    Debt(
      id: 'debt-1',
      contractId: 3421,
      contractNumber: 'SH-3421',
      clientId: 1,
      clientName: 'Nodira Saidova',
      phoneNumber: '998901234567',
      projectName: 'Yuksalish Tower',
      apartmentNumber: '45-A',
      totalAmount: 500000000,
      paidAmount: 242100000,
      remainingAmount: 257900000,
      overdueAmount: 18000000,
      monthlyPayment: 12500000,
      overdueDays: 45,
      maxLateness: 45,
      paidPercentage: 48.4,
      currency: 'UZS',
      status: DebtStatus.overdue,
      contractType: ContractType.installment,
      assignedToName: 'Sardor Aliyev',
    ),
    Debt(
      id: 'debt-2',
      contractId: 3398,
      contractNumber: 'SH-3398',
      clientId: 2,
      clientName: 'Jasur Aliyev',
      phoneNumber: '998912345678',
      projectName: 'Green Park Residence',
      apartmentNumber: '23-B',
      totalAmount: 350000000,
      paidAmount: 280000000,
      remainingAmount: 70000000,
      overdueAmount: 8500000,
      monthlyPayment: 8750000,
      overdueDays: 12,
      maxLateness: 12,
      paidPercentage: 80.0,
      currency: 'UZS',
      status: DebtStatus.overdue,
      contractType: ContractType.installment,
      assignedToName: 'Dilshod Karimov',
    ),
    Debt(
      id: 'debt-3',
      contractId: 3385,
      contractNumber: 'SH-3385',
      clientId: 3,
      clientName: 'Kamila Sultanova',
      phoneNumber: '998933456789',
      projectName: 'Central Business Hub',
      apartmentNumber: '78-C',
      totalAmount: 800000000,
      paidAmount: 400000000,
      remainingAmount: 400000000,
      overdueAmount: 25000000,
      monthlyPayment: 20000000,
      overdueDays: 67,
      maxLateness: 67,
      paidPercentage: 50.0,
      currency: 'UZS',
      status: DebtStatus.overdue,
      contractType: ContractType.installment,
      assignedToName: 'Sardor Aliyev',
    ),
    Debt(
      id: 'debt-4',
      contractId: 3372,
      contractNumber: 'SH-3372',
      clientId: 4,
      clientName: 'Bobur Tursunov',
      phoneNumber: '998944567890',
      projectName: 'Yuksalish Tower',
      apartmentNumber: '12-A',
      totalAmount: 420000000,
      paidAmount: 336000000,
      remainingAmount: 84000000,
      overdueAmount: 0,
      monthlyPayment: 10500000,
      overdueDays: 0,
      maxLateness: 0,
      paidPercentage: 80.0,
      currency: 'UZS',
      status: DebtStatus.active,
      contractType: ContractType.installment,
      assignedToName: 'Dilshod Karimov',
    ),
  ];
}
