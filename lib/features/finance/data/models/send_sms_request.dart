import 'package:equatable/equatable.dart';

/// Request model for sending SMS reminder to debtor
class SendSmsRequest extends Equatable {
  const SendSmsRequest({
    required this.debtId,
    required this.phoneNumber,
    required this.message,
    this.templateId,
  });

  final String debtId;
  final String phoneNumber;
  final String message;
  final int? templateId;

  Map<String, dynamic> toJson() {
    return {
      'debt_id': debtId,
      'phone_number': phoneNumber,
      'message': message,
      if (templateId != null) 'template_id': templateId,
    };
  }

  SendSmsRequest copyWith({
    String? debtId,
    String? phoneNumber,
    String? message,
    int? templateId,
  }) {
    return SendSmsRequest(
      debtId: debtId ?? this.debtId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      message: message ?? this.message,
      templateId: templateId ?? this.templateId,
    );
  }

  @override
  List<Object?> get props => [debtId, phoneNumber, message, templateId];
}

/// SMS Template model for debt reminders
class SmsTemplate extends Equatable {
  const SmsTemplate({
    required this.id,
    required this.name,
    required this.content,
    required this.event,
  });

  final int id;
  final String name;
  final String content;
  final String event; // debt_reminder, payment_due, etc.

  factory SmsTemplate.fromJson(Map<String, dynamic> json) {
    return SmsTemplate(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      content: json['content'] as String? ?? '',
      event: json['event'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, content, event];
}
