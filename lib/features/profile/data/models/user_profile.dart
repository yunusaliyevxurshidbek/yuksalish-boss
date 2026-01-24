import 'package:equatable/equatable.dart';

import 'company.dart';
import 'user_settings.dart';

/// User profile model containing all user information.
class UserProfile extends Equatable {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? avatarUrl;
  final String role;
  final Company? company;
  final UserSettings settings;

  const UserProfile({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.avatarUrl,
    required this.role,
    this.company,
    required this.settings,
  });

  /// Get full name.
  String get fullName => '$firstName $lastName';

  /// Get initials for avatar fallback.
  String get initials {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last'.toUpperCase();
  }

  /// Creates a copy with updated fields.
  UserProfile copyWith({
    String? id,
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? avatarUrl,
    String? role,
    Company? company,
    UserSettings? settings,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      company: company ?? this.company,
      settings: settings ?? this.settings,
    );
  }

  /// Creates from JSON map.
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // Build company from mchj fields if available
    Company? company;
    if (json['mchj_id'] != null && json['mchj_name'] != null) {
      company = Company(
        id: json['mchj_id'].toString(),
        name: json['mchj_name'] as String,
        logoUrl: null,
      );
    }

    // Build settings from notify_* fields
    final settings = UserSettings.defaultSettings().copyWith(
      newLeadsNotifications: json['notify_new_leads'] as bool? ?? true,
      contractsNotifications: json['notify_contract_signed'] as bool? ?? true,
      overdueNotifications: json['notify_payment_overdue'] as bool? ?? false,
    );

    return UserProfile(
      id: json['id'].toString(),
      username: json['username'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatarUrl: json['avatar'] as String?,
      role: json['role'] as String? ?? '',
      company: company,
      settings: settings,
    );
  }

  /// Converts to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'avatar': avatarUrl,
      'role': role,
      if (company != null) 'mchj_id': company!.id,
      if (company != null) 'mchj_name': company!.name,
      'notify_new_leads': settings.newLeadsNotifications,
      'notify_contract_signed': settings.contractsNotifications,
      'notify_payment_overdue': settings.overdueNotifications,
    };
  }

  @override
  List<Object?> get props => [
        id,
        username,
        firstName,
        lastName,
        email,
        phone,
        avatarUrl,
        role,
        company,
        settings,
      ];
}
