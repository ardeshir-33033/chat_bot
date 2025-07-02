class BankAccount {
  final int? id;
  final int? personId;
  final int? bankId;
  final String? accountNumber;
  final String? sheba;
  final double? balance;
  final String? accountType;
  final String? cardNumber;
  final String? bankName;

  BankAccount({
    this.id,
    this.personId,
    this.bankId,
    this.accountNumber,
    this.sheba,
    this.balance,
    this.accountType,
    this.cardNumber,
    this.bankName,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'] as int?,
      personId: json['person_id'] as int?,
      bankId: json['bank_id'] as int?,
      accountNumber: json['account_number'] as String?,
      sheba: json['sheba'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
      accountType: json['account_type'] as String?,
      cardNumber: json['card_number'] as String?,
      bankName: json['bank_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'person_id': personId,
      'bank_id': bankId,
      'account_number': accountNumber,
      'sheba': sheba,
      'balance': balance,
      'account_type': accountType,
      'card_number': cardNumber,
      'bank_name': bankName,
    };
  }
}