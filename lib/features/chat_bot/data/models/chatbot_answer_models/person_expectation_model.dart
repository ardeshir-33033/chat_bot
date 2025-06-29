import 'package:flutter/foundation.dart' show immutable;

@immutable
class PersonExpectationModel {
  final int personId;
  final num? avgIncome;
  final String? incomePeriod;
  final num? avgExpenses;
  final bool? hasDebt;
  final bool? smsPermission;
  final bool? gpsPermission;

  const PersonExpectationModel({
    required this.personId,
    this.avgIncome,
    this.incomePeriod,
    this.avgExpenses,
    this.hasDebt,
    this.smsPermission,
    this.gpsPermission,
  });

  factory PersonExpectationModel.fromJson(Map<String, dynamic> json) {
    return PersonExpectationModel(
      personId: json['person_id'] as int,
      avgIncome: json['avg_income'] as num,
      incomePeriod: json['income_period'] as String,
      avgExpenses: json['avg_expenses'] as num,
      hasDebt: json['has_debt'] as bool,
      smsPermission: json['sms_permission'] as bool,
      gpsPermission: json['gps_permission'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'person_id': personId,
      'avg_income': avgIncome,
      'income_period': incomePeriod,
      'avg_expenses': avgExpenses,
      'has_debt': hasDebt,
      'sms_permission': smsPermission,
      'gps_permission': gpsPermission,
    };
  }

  PersonExpectationModel copyWith({
    int? personId,
    num? avgIncome,
    String? incomePeriod,
    num? avgExpenses,
    bool? hasDebt,
    bool? smsPermission,
    bool? gpsPermission,
  }) {
    return PersonExpectationModel(
      personId: personId ?? this.personId,
      avgIncome: avgIncome ?? this.avgIncome,
      incomePeriod: incomePeriod ?? this.incomePeriod,
      avgExpenses: avgExpenses ?? this.avgExpenses,
      hasDebt: hasDebt ?? this.hasDebt,
      smsPermission: smsPermission ?? this.smsPermission,
      gpsPermission: gpsPermission ?? this.gpsPermission,
    );
  }

  @override
  String toString() {
    return 'PersonExpectation(personId: $personId, avgIncome: $avgIncome, incomePeriod: $incomePeriod, avgExpenses: $avgExpenses, hasDebt: $hasDebt, smsPermission: $smsPermission, gpsPermission: $gpsPermission)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PersonExpectationModel &&
        other.personId == personId &&
        other.avgIncome == avgIncome &&
        other.incomePeriod == incomePeriod &&
        other.avgExpenses == avgExpenses &&
        other.hasDebt == hasDebt &&
        other.smsPermission == smsPermission &&
        other.gpsPermission == gpsPermission;
  }

  @override
  int get hashCode {
    return personId.hashCode ^
    avgIncome.hashCode ^
    incomePeriod.hashCode ^
    avgExpenses.hashCode ^
    hasDebt.hashCode ^
    smsPermission.hashCode ^
    gpsPermission.hashCode;
  }
}