import 'package:equatable/equatable.dart';

/// Types of notifications - maps to API notification types
enum NotificationType {
  // Frontend notifications
  newProject,
  newProperty,
  newBlog,
  
  // Property notifications
  aiRecommendation,
  priceDrop,
  newListing,
  savedSearch,
  
  // Lead notifications
  newLead,
  leadAssigned,
  
  // Task notifications
  newTask,
  taskAssigned,
  taskDue,
  
  // Contract notifications
  newContract,
  
  // Payment notifications
  paymentReceived,
  paymentOverdue,
  
  // Client notifications
  newClient,
  
  // Legacy (for backward compatibility)
  overduePayment,
  approvalPending,
  contractSigned,
}

/// Notification item model
class NotificationItem extends Equatable {
  final int id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? actionRoute;
  
  // Entity IDs from API
  final String? propertyId;
  final String? projectId;
  final int? blogId;
  final int? leadId;
  final int? taskId;
  final int? contractId;
  final int? paymentId;
  final int? clientId;

  const NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.actionRoute,
    this.propertyId,
    this.projectId,
    this.blogId,
    this.leadId,
    this.taskId,
    this.contractId,
    this.paymentId,
    this.clientId,
  });

  /// Get icon emoji for notification type
  String get typeEmoji {
    return switch (type) {
      NotificationType.newLead => '🟢',
      NotificationType.leadAssigned => '✅',
      NotificationType.paymentReceived => '💰',
      NotificationType.paymentOverdue => '⚠️',
      NotificationType.approvalPending => '✅',
      NotificationType.newContract => '📄',
      NotificationType.newTask => '📋',
      NotificationType.taskAssigned => '👤',
      NotificationType.taskDue => '⏰',
      NotificationType.newClient => '👥',
      NotificationType.newProject => '🏢',
      NotificationType.newProperty => '🏠',
      NotificationType.aiRecommendation => '🤖',
      NotificationType.priceDrop => '📉',
      NotificationType.newListing => '📍',
      NotificationType.savedSearch => '💾',
      NotificationType.newBlog => '📰',
      _ => '🔔',
    };
  }

  /// Get formatted time
  String get formattedTime {
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Get formatted date
  String get formattedDate {
    final day = createdAt.day.toString().padLeft(2, '0');
    final month = createdAt.month.toString().padLeft(2, '0');
    final year = createdAt.year;
    return '$day.$month.$year';
  }

  /// Check if notification is from today
  bool get isToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  /// Check if notification is from yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return createdAt.year == yesterday.year &&
        createdAt.month == yesterday.month &&
        createdAt.day == yesterday.day;
  }

  /// Get date group label
  String get dateGroupLabel {
    if (isToday) return 'notifications_group_today';
    if (isYesterday) return 'notifications_group_yesterday';
    return formattedDate;
  }

  /// Copy with updated values
  NotificationItem copyWith({
    int? id,
    NotificationType? type,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? isRead,
    String? actionRoute,
    String? propertyId,
    String? projectId,
    int? blogId,
    int? leadId,
    int? taskId,
    int? contractId,
    int? paymentId,
    int? clientId,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute ?? this.actionRoute,
      propertyId: propertyId ?? this.propertyId,
      projectId: projectId ?? this.projectId,
      blogId: blogId ?? this.blogId,
      leadId: leadId ?? this.leadId,
      taskId: taskId ?? this.taskId,
      contractId: contractId ?? this.contractId,
      paymentId: paymentId ?? this.paymentId,
      clientId: clientId ?? this.clientId,
    );
  }

  /// Create NotificationItem from API JSON response
  factory NotificationItem.fromApiJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String?;
    final type = _parseNotificationType(typeString);

    return NotificationItem(
      id: json['id'] as int? ?? 0,
      type: type,
      title: json['title'] as String? ?? '',
      body: json['message'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      isRead: json['read'] as bool? ?? false,
      propertyId: json['property_id'] as String?,
      projectId: json['project_id'] as String?,
      blogId: json['blog_id'] as int?,
      leadId: json['lead_id'] as int?,
      taskId: json['task_id'] as int?,
      contractId: json['contract_id'] as int?,
      paymentId: json['payment_id'] as int?,
      clientId: json['client_id'] as int?,
    );
  }

  /// Parse notification type string from API to enum
  static NotificationType _parseNotificationType(String? type) {
    return switch (type) {
      'new_project' => NotificationType.newProject,
      'new_property' => NotificationType.newProperty,
      'new_blog' => NotificationType.newBlog,
      'ai_recommendation' => NotificationType.aiRecommendation,
      'price_drop' => NotificationType.priceDrop,
      'new_listing' => NotificationType.newListing,
      'saved_search' => NotificationType.savedSearch,
      'new_lead' => NotificationType.newLead,
      'lead_assigned' => NotificationType.leadAssigned,
      'new_task' => NotificationType.newTask,
      'task_assigned' => NotificationType.taskAssigned,
      'task_due' => NotificationType.taskDue,
      'new_contract' => NotificationType.newContract,
      'payment_received' => NotificationType.paymentReceived,
      'payment_overdue' => NotificationType.paymentOverdue,
      'new_client' => NotificationType.newClient,
      _ => NotificationType.newLead, // Default fallback
    };
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        body,
        createdAt,
        isRead,
        actionRoute,
        propertyId,
        projectId,
        blogId,
        leadId,
        taskId,
        contractId,
        paymentId,
        clientId,
      ];
}
