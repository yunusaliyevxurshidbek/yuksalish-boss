import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:yuksalish_mobile/core/router/app_router.dart';
import 'package:yuksalish_mobile/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  developer.log('Background message: ${message.messageId}', name: 'FCM');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    try {
      // 1. Request permission (iOS + Android 13+)
      await _requestPermission();

      // 2. Setup local notifications
      await _setupLocalNotifications();

      // 3. Create Android notification channel
      await _createAndroidChannel();

      // 4. iOS foreground presentation options
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 5. Get and log FCM token
      final token = await _messaging.getToken();
      developer.log('FCM Token: $token', name: 'FCM');

      // 6. Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        developer.log('FCM Token refreshed: $newToken', name: 'FCM');
        // TODO: Send new token to your server
      });

      // 7. Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // 8. Handle notification taps when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

      // 9. Handle initial message (app opened from terminated state)
      await _handleInitialMessage();

      _initialized = true;
      developer.log('NotificationService initialized', name: 'FCM');
    } catch (e, stack) {
      developer.log('Failed to initialize NotificationService: $e',
          name: 'FCM', error: e, stackTrace: stack);
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    developer.log('Permission status: ${settings.authorizationStatus}',
        name: 'FCM');
  }

  Future<void> _setupLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  Future<void> _createAndroidChannel() async {
    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_channel);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    developer.log('Foreground message: ${message.messageId}', name: 'FCM');
    _showLocalNotification(message);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Encode data payload into the notification payload for tap handling
    final payload = jsonEncode(message.data);

    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      details,
      payload: payload,
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    if (response.payload == null || response.payload!.isEmpty) {
      _navigateTo('/notifications');
      return;
    }

    try {
      final data = jsonDecode(response.payload!) as Map<String, dynamic>;
      _routeFromData(data);
    } catch (e) {
      developer.log('Failed to parse notification payload: $e', name: 'FCM');
      _navigateTo('/notifications');
    }
  }

  void _handleMessageTap(RemoteMessage message) {
    developer.log('Message tap (background): ${message.messageId}', name: 'FCM');
    _routeFromData(message.data);
  }

  Future<void> _handleInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      developer.log('Initial message: ${message.messageId}', name: 'FCM');
      // Delay to ensure router is ready
      Future.delayed(const Duration(milliseconds: 500), () {
        _routeFromData(message.data);
      });
    }
  }

  /// Route based on data payload
  void _routeFromData(Map<String, dynamic> data) {
    try {
      // Priority 1: Explicit route in data
      if (data.containsKey('route')) {
        final route = data['route'] as String;
        _navigateTo(route);
        return;
      }

      // Priority 2: Type-based routing
      final type = data['type'] as String?;
      final id = data['id'] as String?;

      switch (type) {
        case 'order':
          if (id != null) {
            // No order route exists yet - fallback to notifications
            _navigateTo('/notifications');
            return;
          }
          break;
        case 'lead':
          if (id != null) {
            _navigateTo('/leads/$id');
            return;
          }
          break;
        case 'project':
          if (id != null) {
            _navigateTo('/project/$id');
            return;
          }
          break;
        case 'apartment':
          if (id != null) {
            _navigateTo('/apartment/$id');
            return;
          }
          break;
        case 'approval':
          if (id != null) {
            _navigateTo('/approvals/$id');
            return;
          }
          break;
      }

      // Default: Open notifications screen
      _navigateTo('/notifications');
    } catch (e) {
      developer.log('Routing error: $e', name: 'FCM');
      _navigateTo('/notifications');
    }
  }

  void _navigateTo(String route) {
    try {
      developer.log('Navigating to: $route', name: 'FCM');
      router.go(route);
    } catch (e) {
      developer.log('Navigation error: $e', name: 'FCM');
    }
  }

  /// Get current FCM token
  Future<String?> getToken() async {
    return _messaging.getToken();
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    developer.log('Subscribed to topic: $topic', name: 'FCM');
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    developer.log('Unsubscribed from topic: $topic', name: 'FCM');
  }
}
