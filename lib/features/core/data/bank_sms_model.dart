class BankSmsModel {
  final String? bankName;
  final String? accountNumber;
  final String? cardNumber;
  final String? transactionType;
  final String? expenseOrIncome; // 'expense' or 'income'
  final int? amountOfTransaction;
  final int? balance;
  final String? datetime; // ISO 8601 formatted string (e.g., 'YYYY-MM-DDTHH:MM:SS')
  final String? merchantName;
  final String? error; // To indicate if parsing failed or SMS was not a transaction

  BankSmsModel({
    this.bankName,
    this.accountNumber,
    this.cardNumber,
    this.transactionType,
    this.expenseOrIncome,
    this.amountOfTransaction,
    this.balance,
    this.datetime,
    this.merchantName,
    this.error,
  });

  // Optional: A factory constructor to create a model from a map
  factory BankSmsModel.fromJson(Map<String, dynamic> json) {
    return BankSmsModel(
      bankName: json['bank_name'] as String?,
      accountNumber: json['account_number'] as String?,
      cardNumber: json['card_number'] as String?,
      transactionType: json['transaction_type'] as String?,
      expenseOrIncome: json['expense_or_income'] as String?,
      amountOfTransaction: json['amount_of_transaction'] as int?,
      balance: json['balance'] as int?,
      datetime: json['datetime'] as String?,
      merchantName: json['merchant_name'] as String?,
      error: json['error'] as String?,
    );
  }

  // Optional: Convert the model to a map (useful for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'bank_name': bankName,
      'account_number': accountNumber,
      'card_number': cardNumber,
      'transaction_type': transactionType,
      'expense_or_income': expenseOrIncome,
      'amount_of_transaction': amountOfTransaction,
      'balance': balance,
      'datetime': datetime,
      'merchant_name': merchantName,
      'error': error,
    };
  }
}