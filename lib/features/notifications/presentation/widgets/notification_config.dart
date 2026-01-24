import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// Configuration for notification types with icons, colors and translations
class NotificationConfig {
  /// Get configuration for a notification type
  static NotificationTypeConfig getConfig(String typeString) {
    return _configMap[typeString] ?? _defaultConfig;
  }

  /// All notification type configurations
  static const Map<String, NotificationTypeConfig> _configMap = {
    // Lead notifications
    'new_lead': NotificationTypeConfig(
      labelKey: 'notifications_type_new_lead',
      icon: Icons.person_add,
      backgroundColor: Color(0xFFDFEEFF), // bg-blue-100
      iconColor: Color(0xFF2563EB), // text-blue-600
    ),
    'lead_assigned': NotificationTypeConfig(
      labelKey: 'notifications_type_lead_assigned',
      icon: Icons.person_add_alt_1,
      backgroundColor: Color(0xFFEEE5FF), // bg-indigo-100
      iconColor: Color(0xFF4F46E5), // text-indigo-600
    ),

    // Task notifications
    'new_task': NotificationTypeConfig(
      labelKey: 'notifications_type_new_task',
      icon: Icons.assignment,
      backgroundColor: Color(0xFFF3E8FF), // bg-purple-100
      iconColor: Color(0xFFA855F7), // text-purple-600
    ),
    'task_assigned': NotificationTypeConfig(
      labelKey: 'notifications_type_task_assigned',
      icon: Icons.assignment_ind,
      backgroundColor: Color(0xFFF3E8FF), // bg-violet-100
      iconColor: Color(0xFFA855F7), // text-violet-600
    ),
    'task_due': NotificationTypeConfig(
      labelKey: 'notifications_type_task_due',
      icon: Icons.schedule,
      backgroundColor: Color(0xFFFEF3C7), // bg-orange-100
      iconColor: Color(0xFFEA580C), // text-orange-600
    ),

    // Contract notifications
    'new_contract': NotificationTypeConfig(
      labelKey: 'notifications_type_new_contract',
      icon: Icons.description,
      backgroundColor: Color(0xFFDCFCE7), // bg-green-100
      iconColor: Color(0xFF16A34A), // text-green-600
    ),

    // Payment notifications
    'payment_received': NotificationTypeConfig(
      labelKey: 'notifications_type_payment_received',
      icon: Icons.attach_money,
      backgroundColor: Color(0xFFCCFBF1), // bg-emerald-100
      iconColor: Color(0xFF059669), // text-emerald-600
    ),
    'payment_overdue': NotificationTypeConfig(
      labelKey: 'notifications_type_payment_overdue',
      icon: Icons.warning,
      backgroundColor: Color(0xFFFEE2E2), // bg-red-100
      iconColor: Color(0xFFDC2626), // text-red-600
    ),

    // Client notifications
    'new_client': NotificationTypeConfig(
      labelKey: 'notifications_type_new_client',
      icon: Icons.people,
      backgroundColor: Color(0xFFCCFBF1), // bg-teal-100
      iconColor: Color(0xFF0D9488), // text-teal-600
    ),

    // Project notifications
    'new_project': NotificationTypeConfig(
      labelKey: 'notifications_type_new_project',
      icon: Icons.business,
      backgroundColor: Color(0xFFCDFCFE), // bg-cyan-100
      iconColor: Color(0xFF0891B2), // text-cyan-600
    ),

    // Property notifications
    'new_property': NotificationTypeConfig(
      labelKey: 'notifications_type_new_property',
      icon: Icons.house,
      backgroundColor: Color(0xFFCDFCFE), // bg-cyan-100
      iconColor: Color(0xFF0891B2), // text-cyan-600
    ),
    'new_listing': NotificationTypeConfig(
      labelKey: 'notifications_type_new_listing',
      icon: Icons.list,
      backgroundColor: Color(0xFFDCFCE7), // bg-green-100
      iconColor: Color(0xFF16A34A), // text-green-600
    ),
    'ai_recommendation': NotificationTypeConfig(
      labelKey: 'notifications_type_ai_recommendation',
      icon: Icons.smart_toy,
      backgroundColor: Color(0xFFDFEEFF), // bg-blue-100
      iconColor: Color(0xFF2563EB), // text-blue-600
    ),
    'price_drop': NotificationTypeConfig(
      labelKey: 'notifications_type_price_drop',
      icon: Icons.trending_down,
      backgroundColor: Color(0xFFFEE2E2), // bg-red-100
      iconColor: Color(0xFFDC2626), // text-red-600
    ),
    'saved_search': NotificationTypeConfig(
      labelKey: 'notifications_type_saved_search',
      icon: Icons.bookmark,
      backgroundColor: Color(0xFFF3E8FF), // bg-purple-100
      iconColor: Color(0xFFA855F7), // text-purple-600
    ),

    // Blog notifications
    'new_blog': NotificationTypeConfig(
      labelKey: 'notifications_type_new_blog',
      icon: Icons.article,
      backgroundColor: Color(0xFFDFEEFF), // bg-blue-100
      iconColor: Color(0xFF2563EB), // text-blue-600
    ),

    // Approval notifications (legacy support)
    'approvalPending': NotificationTypeConfig(
      labelKey: 'notifications_type_approval_pending',
      icon: Icons.check_circle,
      backgroundColor: Color(0xFFE0F2FE), // bg-sky-100
      iconColor: Color(0xFF0284C7), // text-sky-600
    ),

    // Overdue payment (legacy support)
    'overduePayment': NotificationTypeConfig(
      labelKey: 'notifications_type_overdue_payment',
      icon: Icons.warning,
      backgroundColor: Color(0xFFFEE2E2), // bg-red-100
      iconColor: Color(0xFFDC2626), // text-red-600
    ),
  };

  static const NotificationTypeConfig _defaultConfig = NotificationTypeConfig(
    labelKey: 'notifications_type_default',
    icon: Icons.notifications,
    backgroundColor: Color(0xFFF3F4F6), // bg-gray-100
    iconColor: Color(0xFF6B7280), // text-gray-600
  );
}

/// Configuration for a notification type
class NotificationTypeConfig {
  final String labelKey;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const NotificationTypeConfig({
    required this.labelKey,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  String label(BuildContext context) => labelKey.tr();
}

/// Localization keys for notification types
const notificationTypeLabelKeys = <String, String>{
  'new_lead': 'notifications_type_new_lead',
  'lead_assigned': 'notifications_type_lead_assigned',
  'new_task': 'notifications_type_new_task',
  'task_assigned': 'notifications_type_task_assigned',
  'task_due': 'notifications_type_task_due',
  'new_contract': 'notifications_type_new_contract',
  'payment_received': 'notifications_type_payment_received',
  'payment_overdue': 'notifications_type_payment_overdue',
  'new_client': 'notifications_type_new_client',
  'new_project': 'notifications_type_new_project',
  'new_property': 'notifications_type_new_property',
  'new_listing': 'notifications_type_new_listing',
  'ai_recommendation': 'notifications_type_ai_recommendation',
  'price_drop': 'notifications_type_price_drop',
  'saved_search': 'notifications_type_saved_search',
  'new_blog': 'notifications_type_new_blog',
  'approvalPending': 'notifications_type_approval_pending',
  'overduePayment': 'notifications_type_overdue_payment',
};
