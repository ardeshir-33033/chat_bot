import 'dart:convert';

class SmsTransactionModel {
  final double? amount;
  final String? description;
  final int? expenseIncomeCategoryId;
  final int? fixIncomeExpenseId;
  final String? rawData;
  final bool? fromSms;
  final int? personId;
  final int? bankAccountId;
  final int? bankPhoneId;
  final double? latitude;
  final double? longitude;
  final String? address;

  SmsTransactionModel({
    this.amount,
    this.description,
    this.expenseIncomeCategoryId,
    this.fixIncomeExpenseId,
    this.rawData,
    this.fromSms,
    this.personId,
    this.bankAccountId,
    this.bankPhoneId,
    this.latitude,
    this.longitude,
    this.address,
  });

  // Factory constructor to create an SmsTransactionModel object from a JSON map
  factory SmsTransactionModel.fromJson(Map<String, dynamic> json) {
    return SmsTransactionModel(
      amount: (json['amount'] as num?)?.toDouble(), // Handle null and convert to double
      description: json['description'] as String?,
      expenseIncomeCategoryId: json['expense_income_category_id'] as int?,
      fixIncomeExpenseId: json['fix_income_expense_id'] as int?,
      rawData: json['raw_data'] as String?,
      fromSms: json['from_sms'] as bool?,
      personId: json['person_id'] as int?,
      bankAccountId: json['bank_account_id'] as int?,
      bankPhoneId: json['bank_phone_id'] as int?,
      latitude: (json['latitude'] as num?)?.toDouble(), // Handle null and convert to double
      longitude: (json['longitude'] as num?)?.toDouble(), // Handle null and convert to double
      address: json['address'] as String?,
    );
  }

  // Method to convert an SmsTransactionModel object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'description': description,
      'expense_income_category_id': expenseIncomeCategoryId,
      'fix_income_expense_id': fixIncomeExpenseId,
      'raw_data': rawData,
      'from_sms': fromSms,
      'person_id': personId,
      'bank_account_id': bankAccountId,
      'bank_phone_id': bankPhoneId,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  @override
  String toString() {
    return 'SmsTransactionModel(\n'
        '  amount: $amount,\n'
        '  description: $description,\n'
        '  expenseIncomeCategoryId: $expenseIncomeCategoryId,\n'
        '  fixIncomeExpenseId: $fixIncomeExpenseId,\n'
        '  rawData: $rawData,\n'
        '  fromSms: $fromSms,\n'
        '  personId: $personId,\n'
        '  bankAccountId: $bankAccountId,\n'
        '  bankPhoneId: $bankPhoneId,\n'
        '  latitude: $latitude,\n'
        '  longitude: $longitude,\n'
        '  address: $address\n'
        ')';
  }
}
