class MostExpenseCategoryModel {
  final int personId;
  final int expenseCategoryId;

  MostExpenseCategoryModel({
    required this.personId,
    required this.expenseCategoryId,
  });

  factory MostExpenseCategoryModel.fromJson(Map<String, dynamic> json) {
    return MostExpenseCategoryModel(
      personId: json['person_id'] as int,
      expenseCategoryId: json['expense_category_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'person_id': personId,
      'expense_category_id': expenseCategoryId,
    };
  }

  @override
  String toString() {
    return 'MostExpenseCategoryModel(personId: $personId, expenseCategoryId: $expenseCategoryId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MostExpenseCategoryModel &&
        other.personId == personId &&
        other.expenseCategoryId == expenseCategoryId;
  }

  @override
  int get hashCode => personId.hashCode ^ expenseCategoryId.hashCode;
}