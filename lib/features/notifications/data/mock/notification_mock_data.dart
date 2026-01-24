import '../models/notification_model.dart';

/// Generates mock notification data for testing and development.
class NotificationMockData {
  static const int pageSize = 6;

  /// Generates a page of mock notifications.
  /// Returns empty list if page > 2.
  static List<NotificationModel> generatePage(int page) {
    if (page > 2) return [];

    final now = DateTime.now();
    final seed = [
      NotificationModel(
        id: 'n-$page-0',
        type: NotificationType.paymentReceived,
        title: "To'lov qabul qilindi",
        message: '50 000 000 UZS',
        subtitle: 'Temur Temirov',
        createdAt: now.subtract(Duration(minutes: 30 + page * 12)),
        isUrgent: false,
        targetType: 'payment',
      ),
      NotificationModel(
        id: 'n-$page-1',
        type: NotificationType.approvalRequired,
        title: "Tasdiqlash kutmoqda",
        message: 'Sement xaridi - 875 mln',
        subtitle: 'IT Park loyihasi',
        createdAt: now.subtract(Duration(hours: 2 + page)),
        isUrgent: true,
        targetType: 'approval',
      ),
      NotificationModel(
        id: 'n-$page-2',
        type: NotificationType.newLead,
        title: 'Yangi lid',
        message: 'Alisher Karimov',
        subtitle: 'New York loyihasi',
        createdAt: now.subtract(Duration(days: 1, hours: 1 + page)),
        isUrgent: false,
        targetType: 'lead',
      ),
      NotificationModel(
        id: 'n-$page-3',
        type: NotificationType.overduePayment,
        title: "Muddati o'tgan to'lov",
        message: 'Nodira Saidova - 18 mln',
        subtitle: "3 kun muddati o'tgan",
        createdAt: now.subtract(Duration(days: 3 + page)),
        isUrgent: true,
        targetType: 'payment',
      ),
      NotificationModel(
        id: 'n-$page-4',
        type: NotificationType.contractSigned,
        title: 'Shartnoma imzolandi',
        message: 'YD-3254 - 420 mln UZS',
        subtitle: "Qurilish bo'limi",
        createdAt: now.subtract(Duration(days: 4 + page)),
        isUrgent: false,
        targetType: 'contract',
      ),
      NotificationModel(
        id: 'n-$page-5',
        type: NotificationType.newLead,
        title: 'Yangi lid',
        message: 'Aziza Abdukarimova',
        subtitle: 'Tashkent City loyihasi',
        createdAt: now.subtract(Duration(minutes: 90 + page * 10)),
        isUrgent: false,
        targetType: 'lead',
      ),
    ];

    return seed.take(pageSize).toList();
  }
}
