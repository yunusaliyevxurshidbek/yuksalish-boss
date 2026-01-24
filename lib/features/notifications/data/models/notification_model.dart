import 'package:equatable/equatable.dart';

enum NotificationType {
  newLead,
  paymentReceived,
  overduePayment,
  approvalRequired,
  contractSigned,
}

class NotificationModel extends Equatable {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String? subtitle;
  final DateTime createdAt;
  final bool isRead;
  final bool isUrgent;
  final String? targetId;
  final String? targetType;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.subtitle,
    required this.createdAt,
    this.isRead = false,
    this.isUrgent = false,
    this.targetId,
    this.targetType,
  });

  String get timeLabel {
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  bool get isToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return createdAt.year == yesterday.year &&
        createdAt.month == yesterday.month &&
        createdAt.day == yesterday.day;
  }

  String get dateGroupLabel {
    if (isToday) return 'Bugun';
    if (isYesterday) return 'Kecha';
    return 'Oldingi';
  }

  NotificationModel copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? message,
    String? subtitle,
    DateTime? createdAt,
    bool? isRead,
    bool? isUrgent,
    String? targetId,
    String? targetType,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      subtitle: subtitle ?? this.subtitle,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      isUrgent: isUrgent ?? this.isUrgent,
      targetId: targetId ?? this.targetId,
      targetType: targetType ?? this.targetType,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        message,
        subtitle,
        createdAt,
        isRead,
        isUrgent,
        targetId,
        targetType,
      ];
}
