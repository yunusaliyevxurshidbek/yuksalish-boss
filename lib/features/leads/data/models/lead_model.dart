import 'package:equatable/equatable.dart';

/// Enum for lead source types
enum LeadSource {
  website,
  instagram,
  telegram,
  call,
  referral,
  walkIn,
  other;

  static LeadSource fromString(String? value) {
    return switch (value) {
      'website' => LeadSource.website,
      'instagram' => LeadSource.instagram,
      'telegram' => LeadSource.telegram,
      'call' => LeadSource.call,
      'referral' => LeadSource.referral,
      'walk_in' => LeadSource.walkIn,
      'other' => LeadSource.other,
      _ => LeadSource.other,
    };
  }

  String toApiString() {
    return switch (this) {
      LeadSource.website => 'website',
      LeadSource.instagram => 'instagram',
      LeadSource.telegram => 'telegram',
      LeadSource.call => 'call',
      LeadSource.referral => 'referral',
      LeadSource.walkIn => 'walk_in',
      LeadSource.other => 'other',
    };
  }

  String get displayName {
    return switch (this) {
      LeadSource.website => 'Veb-sayt',
      LeadSource.instagram => 'Instagram',
      LeadSource.telegram => 'Telegram',
      LeadSource.call => "Qo'ng'iroq",
      LeadSource.referral => 'Tavsiya',
      LeadSource.walkIn => 'Tashrif',
      LeadSource.other => 'Boshqa',
    };
  }

  String get translationKey {
    return switch (this) {
      LeadSource.website => 'leads_source_website',
      LeadSource.instagram => 'leads_source_instagram',
      LeadSource.telegram => 'leads_source_telegram',
      LeadSource.call => 'leads_source_call',
      LeadSource.referral => 'leads_source_referral',
      LeadSource.walkIn => 'leads_source_walk_in',
      LeadSource.other => 'leads_source_other',
    };
  }
}

/// Enum for lead stage types
enum LeadStage {
  newLead,
  contacted,
  qualified,
  showing,
  negotiation,
  reservation,
  contract,
  won,
  lost;

  static LeadStage fromString(String? value) {
    return switch (value) {
      'new' => LeadStage.newLead,
      'contacted' => LeadStage.contacted,
      'qualified' => LeadStage.qualified,
      'showing' => LeadStage.showing,
      'negotiation' => LeadStage.negotiation,
      'reservation' => LeadStage.reservation,
      'contract' => LeadStage.contract,
      'won' => LeadStage.won,
      'lost' => LeadStage.lost,
      _ => LeadStage.newLead,
    };
  }

  String toApiString() {
    return switch (this) {
      LeadStage.newLead => 'new',
      LeadStage.contacted => 'contacted',
      LeadStage.qualified => 'qualified',
      LeadStage.showing => 'showing',
      LeadStage.negotiation => 'negotiation',
      LeadStage.reservation => 'reservation',
      LeadStage.contract => 'contract',
      LeadStage.won => 'won',
      LeadStage.lost => 'lost',
    };
  }

  String get displayName {
    return switch (this) {
      LeadStage.newLead => 'Yangi',
      LeadStage.contacted => "Bog'lanilgan",
      LeadStage.qualified => 'Malakali',
      LeadStage.showing => "Ko'rsatuv",
      LeadStage.negotiation => 'Muzokara',
      LeadStage.reservation => 'Bron',
      LeadStage.contract => 'Shartnoma',
      LeadStage.won => 'Yutilgan',
      LeadStage.lost => "Yo'qotilgan",
    };
  }

  String get translationKey {
    return switch (this) {
      LeadStage.newLead => 'leads_stage_new',
      LeadStage.contacted => 'leads_stage_contacted',
      LeadStage.qualified => 'leads_stage_qualified',
      LeadStage.showing => 'leads_stage_showing',
      LeadStage.negotiation => 'leads_stage_negotiation',
      LeadStage.reservation => 'leads_stage_reservation',
      LeadStage.contract => 'leads_stage_contract',
      LeadStage.won => 'leads_stage_won',
      LeadStage.lost => 'leads_stage_lost',
    };
  }
}

/// Lead model representing a CRM lead
class Lead extends Equatable {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final LeadSource source;
  final String? notes;
  final String? propertyInterest;
  final LeadStage stage;
  final double? expectedAmount;
  final List<String> tags;
  final int? clientId;
  final String? clientName;
  final int? mchjId;
  final String? mchjName;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Lead({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    required this.source,
    this.notes,
    this.propertyInterest,
    required this.stage,
    this.expectedAmount,
    this.tags = const [],
    this.clientId,
    this.clientName,
    this.mchjId,
    this.mchjName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      source: LeadSource.fromString(json['source'] as String?),
      notes: json['notes'] as String?,
      propertyInterest: json['property_interest'] as String?,
      stage: LeadStage.fromString(json['stage'] as String?),
      expectedAmount: _parseDecimal(json['expected_amount']),
      tags: _parseTags(json['tags']),
      clientId: json['client'] as int?,
      clientName: json['client_name'] as String?,
      mchjId: json['mchj_id'] as int?,
      mchjName: json['mchj_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  static List<String> _parseTags(dynamic tags) {
    if (tags == null) return [];
    if (tags is List) {
      return tags.map((e) => e.toString()).toList();
    }
    return [];
  }

  static double? _parseDecimal(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'source': source.toApiString(),
      'notes': notes,
      'property_interest': propertyInterest,
      'stage': stage.toApiString(),
      'expected_amount': expectedAmount?.toString(),
      'tags': tags,
      'client': clientId,
      'client_name': clientName,
      'mchj_id': mchjId,
      'mchj_name': mchjName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        email,
        source,
        notes,
        propertyInterest,
        stage,
        expectedAmount,
        tags,
        clientId,
        clientName,
        mchjId,
        mchjName,
        createdAt,
        updatedAt,
      ];
}
