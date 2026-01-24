import '../models/approval.dart';

/// Repository for managing approval requests
abstract class ApprovalsRepository {
  /// Get all approvals
  Future<List<Approval>> getApprovals();

  /// Get pending approvals count
  Future<int> getPendingCount();

  /// Approve a request
  Future<Approval> approve(String id, {String? comment});

  /// Reject a request
  Future<Approval> reject(String id, String reason);

  /// Add comment to approval
  Future<Approval> addComment(String id, String comment);
}

/// Implementation with mock data
class ApprovalsRepositoryImpl implements ApprovalsRepository {
  final List<Approval> _approvals = _generateMockApprovals();

  @override
  Future<List<Approval>> getApprovals() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.from(_approvals)
      ..sort((a, b) {
        // Urgent first, then by date
        if (a.isUrgent && !b.isUrgent) return -1;
        if (!a.isUrgent && b.isUrgent) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });
  }

  @override
  Future<int> getPendingCount() async {
    return _approvals
        .where((a) => a.status == ApprovalStatus.pending)
        .length;
  }

  @override
  Future<Approval> approve(String id, {String? comment}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _approvals.indexWhere((a) => a.id == id);
    if (index != -1) {
      final updated = _approvals[index].copyWith(
        status: ApprovalStatus.approved,
        comment: comment,
      );
      _approvals[index] = updated;
      return updated;
    }
    throw Exception('Approval not found');
  }

  @override
  Future<Approval> reject(String id, String reason) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _approvals.indexWhere((a) => a.id == id);
    if (index != -1) {
      final updated = _approvals[index].copyWith(
        status: ApprovalStatus.rejected,
        comment: reason,
      );
      _approvals[index] = updated;
      return updated;
    }
    throw Exception('Approval not found');
  }

  @override
  Future<Approval> addComment(String id, String comment) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _approvals.indexWhere((a) => a.id == id);
    if (index != -1) {
      final updated = _approvals[index].copyWith(comment: comment);
      _approvals[index] = updated;
      return updated;
    }
    throw Exception('Approval not found');
  }

  static List<Approval> _generateMockApprovals() {
    final now = DateTime.now();
    return [
      // Purchase approvals
      Approval(
        id: 'apr-001',
        type: ApprovalType.purchase,
        priority: ApprovalPriority.urgent,
        status: ApprovalStatus.pending,
        createdAt: now.subtract(const Duration(hours: 2)),
        requestedBy: 'Jasur Aliyev',
        data: {
          'materialName': 'Sement M400',
          'quantity': 500,
          'unit': 'tonna',
          'unitPrice': 1750000,
          'totalAmount': 875000000,
          'project': 'New York Residence',
          'supplier': 'Qizilqum Sement',
          'attachments': 2,
        },
      ),
      Approval(
        id: 'apr-002',
        type: ApprovalType.purchase,
        priority: ApprovalPriority.normal,
        status: ApprovalStatus.pending,
        createdAt: now.subtract(const Duration(hours: 5)),
        requestedBy: 'Bobur Karimov',
        data: {
          'materialName': 'Armatura 12mm',
          'quantity': 25,
          'unit': 'tonna',
          'unitPrice': 14500000,
          'totalAmount': 362500000,
          'project': 'Green Park',
          'supplier': 'Bekobod Metall',
          'attachments': 1,
        },
      ),
      Approval(
        id: 'apr-003',
        type: ApprovalType.purchase,
        priority: ApprovalPriority.normal,
        status: ApprovalStatus.pending,
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
        requestedBy: 'Sanjar Toshev',
        data: {
          'materialName': 'G\'isht M150',
          'quantity': 100000,
          'unit': 'dona',
          'unitPrice': 1200,
          'totalAmount': 120000000,
          'project': 'Millennium Tower',
          'supplier': 'Toshkent G\'isht',
          'attachments': 0,
        },
      ),

      // Payment approvals
      Approval(
        id: 'apr-004',
        type: ApprovalType.payment,
        priority: ApprovalPriority.normal,
        status: ApprovalStatus.pending,
        createdAt: now.subtract(const Duration(hours: 4)),
        requestedBy: 'Nodira Rahimova',
        data: {
          'amount': 120000000,
          'recipient': '"BuildMaster" MChJ',
          'purpose': 'Qurilish materiallari uchun to\'lov',
          'invoiceNumber': 'INV-2025-0142',
          'bankAccount': '20208000900123456789',
          'attachments': 1,
        },
      ),
      Approval(
        id: 'apr-005',
        type: ApprovalType.payment,
        priority: ApprovalPriority.urgent,
        status: ApprovalStatus.pending,
        createdAt: now.subtract(const Duration(hours: 1)),
        requestedBy: 'Akmal Yusupov',
        data: {
          'amount': 85000000,
          'recipient': '"EcoStroy" MChJ',
          'purpose': 'Quvur va santexnika materiallari',
          'invoiceNumber': 'INV-2025-0156',
          'bankAccount': '20208000900987654321',
          'attachments': 2,
        },
      ),

      // HR approvals
      Approval(
        id: 'apr-006',
        type: ApprovalType.hr,
        priority: ApprovalPriority.normal,
        status: ApprovalStatus.pending,
        createdAt: now.subtract(const Duration(hours: 6)),
        requestedBy: 'Dilnoza Azimova',
        data: {
          'employeeName': 'Kamila Rustamova',
          'position': 'Sotuv menejeri',
          'department': 'Sotuv bo\'limi',
          'salary': 8000000,
          'startDate': '01.02.2025',
          'type': 'Yangi xodim',
        },
      ),
      Approval(
        id: 'apr-007',
        type: ApprovalType.hr,
        priority: ApprovalPriority.normal,
        status: ApprovalStatus.pending,
        createdAt: now.subtract(const Duration(days: 1)),
        requestedBy: 'Dilnoza Azimova',
        data: {
          'employeeName': 'Bekzod Abdullayev',
          'position': 'Prораб',
          'department': 'Qurilish',
          'salary': 12000000,
          'startDate': '15.02.2025',
          'type': 'Yangi xodim',
        },
      ),
      Approval(
        id: 'apr-008',
        type: ApprovalType.hr,
        priority: ApprovalPriority.normal,
        status: ApprovalStatus.pending,
        createdAt: now.subtract(const Duration(days: 2)),
        requestedBy: 'Dilnoza Azimova',
        data: {
          'employeeName': 'Otabek Normatov',
          'position': 'Katta injener',
          'department': 'Texnik',
          'salary': 15000000,
          'previousSalary': 12000000,
          'type': 'Maosh oshirish',
        },
      ),

      // Budget approvals
      Approval(
        id: 'apr-009',
        type: ApprovalType.budget,
        priority: ApprovalPriority.normal,
        status: ApprovalStatus.pending,
        createdAt: now.subtract(const Duration(hours: 8)),
        requestedBy: 'Sherali Tursunov',
        data: {
          'project': 'Green Park',
          'additionalAmount': 450000000,
          'currentBudget': 12500000000,
          'newBudget': 12950000000,
          'reason': 'Material narxi oshgani tufayli',
          'category': 'Qurilish materiallari',
        },
      ),
      Approval(
        id: 'apr-010',
        type: ApprovalType.budget,
        priority: ApprovalPriority.urgent,
        status: ApprovalStatus.pending,
        createdAt: now.subtract(const Duration(hours: 3)),
        requestedBy: 'Ravshan Mirzayev',
        data: {
          'project': 'New York Residence',
          'additionalAmount': 280000000,
          'currentBudget': 18000000000,
          'newBudget': 18280000000,
          'reason': 'Lift jihozlari narxining o\'zgarishi',
          'category': 'Jihozlar',
        },
      ),

      // Discount approvals
      Approval(
        id: 'apr-011',
        type: ApprovalType.discount,
        priority: ApprovalPriority.normal,
        status: ApprovalStatus.pending,
        createdAt: now.subtract(const Duration(hours: 7)),
        requestedBy: 'Malika Sadikova',
        data: {
          'clientName': 'Abdulla Karimov',
          'apartment': '#45',
          'project': 'New York Residence',
          'originalPrice': 850000000,
          'discountPercent': 5,
          'discountAmount': 42500000,
          'finalPrice': 807500000,
          'reason': 'Doimiy mijoz',
        },
      ),
      Approval(
        id: 'apr-012',
        type: ApprovalType.discount,
        priority: ApprovalPriority.normal,
        status: ApprovalStatus.pending,
        createdAt: now.subtract(const Duration(days: 1, hours: 5)),
        requestedBy: 'Javohir Rahimov',
        data: {
          'clientName': 'Zarina Umarova',
          'apartment': '#78',
          'project': 'Green Park',
          'originalPrice': 620000000,
          'discountPercent': 3,
          'discountAmount': 18600000,
          'finalPrice': 601400000,
          'reason': 'To\'liq to\'lov',
        },
      ),
    ];
  }
}
