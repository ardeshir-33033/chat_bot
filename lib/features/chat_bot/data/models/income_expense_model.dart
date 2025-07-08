class IncomeExpenseModel {
  String? title;
  double? amount;
  int? personId;
  int? categoryId;

  IncomeExpenseModel({this.title, this.amount, this.personId, this.categoryId});

  factory IncomeExpenseModel.fromJson(Map<String, dynamic> json) {
    return IncomeExpenseModel(
      title: json['title'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      personId: json['person_id'] as int?,
      categoryId: json['expense_income_category_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'person_id': personId,
      'expense_income_category_id': categoryId,
    };
  }

  IncomeExpenseModel copyWith({
    String? title,
    double? amount,
    int? personId,
    int? categoryId,
  }) {
    return IncomeExpenseModel(
      title: title ?? this.title,
      amount: amount ?? this.amount,
      personId: personId ?? this.personId,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
