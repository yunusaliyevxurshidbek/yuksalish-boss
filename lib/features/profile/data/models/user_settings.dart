import 'package:equatable/equatable.dart';

/// User settings and preferences model.
class UserSettings extends Equatable {
  // Security settings
  final bool biometricEnabled;
  final int sessionTimeoutMinutes;

  // Notification settings
  final bool pushNotifications;
  final bool emailNotifications;
  final bool soundEnabled;
  final bool vibrationEnabled;

  // Notification type preferences
  final bool newLeadsNotifications;
  final bool paymentsNotifications;
  final bool overdueNotifications;
  final bool approvalsNotifications;
  final bool contractsNotifications;

  // App settings
  final String language;
  final bool darkMode;

  const UserSettings({
    required this.biometricEnabled,
    required this.sessionTimeoutMinutes,
    required this.pushNotifications,
    required this.emailNotifications,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.newLeadsNotifications,
    required this.paymentsNotifications,
    required this.overdueNotifications,
    required this.approvalsNotifications,
    required this.contractsNotifications,
    required this.language,
    required this.darkMode,
  });

  /// Default settings for new users.
  factory UserSettings.defaultSettings() {
    return const UserSettings(
      biometricEnabled: false,
      sessionTimeoutMinutes: 15,
      pushNotifications: true,
      emailNotifications: true,
      soundEnabled: true,
      vibrationEnabled: true,
      newLeadsNotifications: true,
      paymentsNotifications: true,
      overdueNotifications: true,
      approvalsNotifications: true,
      contractsNotifications: true,
      language: 'uz_latin',
      darkMode: false,
    );
  }

  /// Creates a copy with updated fields.
  UserSettings copyWith({
    bool? biometricEnabled,
    int? sessionTimeoutMinutes,
    bool? pushNotifications,
    bool? emailNotifications,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? newLeadsNotifications,
    bool? paymentsNotifications,
    bool? overdueNotifications,
    bool? approvalsNotifications,
    bool? contractsNotifications,
    String? language,
    bool? darkMode,
  }) {
    return UserSettings(
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      sessionTimeoutMinutes:
          sessionTimeoutMinutes ?? this.sessionTimeoutMinutes,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      newLeadsNotifications:
          newLeadsNotifications ?? this.newLeadsNotifications,
      paymentsNotifications:
          paymentsNotifications ?? this.paymentsNotifications,
      overdueNotifications: overdueNotifications ?? this.overdueNotifications,
      approvalsNotifications:
          approvalsNotifications ?? this.approvalsNotifications,
      contractsNotifications:
          contractsNotifications ?? this.contractsNotifications,
      language: language ?? this.language,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  /// Creates from JSON map.
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      biometricEnabled: json['biometric_enabled'] as bool? ?? false,
      sessionTimeoutMinutes: json['session_timeout_minutes'] as int? ?? 15,
      pushNotifications: json['push_notifications'] as bool? ?? true,
      emailNotifications: json['email_notifications'] as bool? ?? true,
      soundEnabled: json['sound_enabled'] as bool? ?? true,
      vibrationEnabled: json['vibration_enabled'] as bool? ?? true,
      newLeadsNotifications: json['new_leads_notifications'] as bool? ?? true,
      paymentsNotifications: json['payments_notifications'] as bool? ?? true,
      overdueNotifications: json['overdue_notifications'] as bool? ?? true,
      approvalsNotifications: json['approvals_notifications'] as bool? ?? true,
      contractsNotifications: json['contracts_notifications'] as bool? ?? true,
      language: json['language'] as String? ?? 'uz_latin',
      darkMode: json['dark_mode'] as bool? ?? false,
    );
  }

  /// Converts to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'biometric_enabled': biometricEnabled,
      'session_timeout_minutes': sessionTimeoutMinutes,
      'push_notifications': pushNotifications,
      'email_notifications': emailNotifications,
      'sound_enabled': soundEnabled,
      'vibration_enabled': vibrationEnabled,
      'new_leads_notifications': newLeadsNotifications,
      'payments_notifications': paymentsNotifications,
      'overdue_notifications': overdueNotifications,
      'approvals_notifications': approvalsNotifications,
      'contracts_notifications': contractsNotifications,
      'language': language,
      'dark_mode': darkMode,
    };
  }

  /// Get language display name.
  String get languageDisplayName {
    switch (language) {
      case 'uz_latin':
        return "O'zbek (Lotin)";
      case 'uz_cyrillic':
        return 'Ўзбек (Кирилл)';
      case 'ru':
        return 'Русский';
      case 'en':
        return 'English';
      default:
        return "O'zbek (Lotin)";
    }
  }

  /// Get session timeout display text.
  String get sessionTimeoutDisplayText {
    if (sessionTimeoutMinutes >= 60) {
      return '${sessionTimeoutMinutes ~/ 60} soat';
    }
    return '$sessionTimeoutMinutes daq';
  }

  @override
  List<Object?> get props => [
        biometricEnabled,
        sessionTimeoutMinutes,
        pushNotifications,
        emailNotifications,
        soundEnabled,
        vibrationEnabled,
        newLeadsNotifications,
        paymentsNotifications,
        overdueNotifications,
        approvalsNotifications,
        contractsNotifications,
        language,
        darkMode,
      ];
}
