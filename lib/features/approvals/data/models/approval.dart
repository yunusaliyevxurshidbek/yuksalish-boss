import 'package:equatable/equatable.dart';

/// Types of approval requests
enum ApprovalType {
  purchase, // Xarid
  payment, // To'lov
  hr, // HR
  budget, // Byudjet
  discount, // Chegirma
}

/// Priority levels for approvals
enum ApprovalPriority {
  normal,
  urgent, // Shoshilinch
}

/// Status of approval request
enum ApprovalStatus {
  pending, // Kutmoqda
  approved, // Tasdiqlangan
  rejected, // Rad etilgan
}

/// Approval request model
class Approval extends Equatable {
  final String id;
  final ApprovalType type;
  final ApprovalPriority priority;
  final ApprovalStatus status;
  final DateTime createdAt;
  final String requestedBy;
  final Map<String, dynamic> data;
  final String? comment;

  const Approval({
    required this.id,
    required this.type,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.requestedBy,
    required this.data,
    this.comment,
  });

  /// Get type label in Uzbek
  String get typeLabel {
    return switch (type) {
      ApprovalType.purchase => 'Xarid',
      ApprovalType.payment => "To'lov",
      ApprovalType.hr => 'HR',
      ApprovalType.budget => 'Byudjet',
      ApprovalType.discount => 'Chegirma',
    };
  }

  /// Get type icon
  String get typeEmoji {
    return switch (type) {
      ApprovalType.purchase => '🛒',
      ApprovalType.payment => '💰',
      ApprovalType.hr => '👤',
      ApprovalType.budget => '📊',
      ApprovalType.discount => '🏷️',
    };
  }

  /// Get status label in Uzbek
  String get statusLabel {
    return switch (status) {
      ApprovalStatus.pending => 'Kutmoqda',
      ApprovalStatus.approved => 'Tasdiqlangan',
      ApprovalStatus.rejected => 'Rad etilgan',
    };
  }

  /// Check if urgent
  bool get isUrgent => priority == ApprovalPriority.urgent;

  /// Get title based on type
  String get title {
    return switch (type) {
      ApprovalType.purchase => data['materialName'] ?? 'Material xaridi',
      ApprovalType.payment =>
        "To'lov: ${data['recipient'] ?? 'Noma\'lum'}",
      ApprovalType.hr => data['employeeName'] ?? 'Xodim',
      ApprovalType.budget =>
        "Byudjet: ${data['project'] ?? 'Loyiha'}",
      ApprovalType.discount =>
        "Chegirma: ${data['clientName'] ?? 'Mijoz'}",
    };
  }

  /// Get amount based on type
  double get amount {
    return switch (type) {
      ApprovalType.purchase =>
        (data['totalAmount'] as num?)?.toDouble() ?? 0,
      ApprovalType.payment =>
        (data['amount'] as num?)?.toDouble() ?? 0,
      ApprovalType.hr =>
        (data['salary'] as num?)?.toDouble() ?? 0,
      ApprovalType.budget =>
        (data['additionalAmount'] as num?)?.toDouble() ?? 0,
      ApprovalType.discount =>
        (data['discountAmount'] as num?)?.toDouble() ?? 0,
    };
  }

  /// Format amount as string
  String get formattedAmount {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)} mlrd';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(0)} mln';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)} ming';
    }
    return amount.toStringAsFixed(0);
  }

  /// Copy with updated values
  Approval copyWith({
    String? id,
    ApprovalType? type,
    ApprovalPriority? priority,
    ApprovalStatus? status,
    DateTime? createdAt,
    String? requestedBy,
    Map<String, dynamic>? data,
    String? comment,
  }) {
    return Approval(
      id: id ?? this.id,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      requestedBy: requestedBy ?? this.requestedBy,
      data: data ?? this.data,
      comment: comment ?? this.comment,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        priority,
        status,
        createdAt,
        requestedBy,
        data,
        comment,
      ];
}
