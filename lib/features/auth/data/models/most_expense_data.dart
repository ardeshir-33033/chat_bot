class ExpenseCategory {
  final int id;
  final int? personId;
  final String title;

  ExpenseCategory({
    required this.id,
     this.personId,
    required this.title,
  });

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'person_id': personId,
      'category_title': title,
    };
  }
}

class ExpenseCategoryList {
  final List<ExpenseCategory> categories;

  ExpenseCategoryList(this.categories);

  factory ExpenseCategoryList.fromJson(List<dynamic> json) {
    return ExpenseCategoryList(
      json.map((item) => ExpenseCategory.fromJson(item)).toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return categories.map((category) => category.toJson()).toList();
  }
}


class MostExpenseData {
  final String  list =
      '''
      [
{
    "id": 1,
    "title": "مسکن و اجاره",
    "expense_or_income": false,
    "person_id": null,
    "is_public": true,
    "created_at": "2025-07-08T11:44:46.297535",
    "updated_at": "2025-07-08T11:44:46.297535"
  },
  {
    "id": 2,
    "title": "خدمات عمومی و شهری",
    "expense_or_income": false,
    "person_id": null,
    "is_public": true,
    "created_at": "2025-07-08T11:44:46.298584",
    "updated_at": "2025-07-08T11:44:46.298584"
  },
  {
    "id": 3,
    "title": "حمل و نقل",
    "expense_or_income": false,
    "person_id": null,
    "is_public": true,
    "created_at": "2025-07-08T11:44:46.298584",
    "updated_at": "2025-07-08T11:44:46.298584"
  },
  {
    "id": 4,
    "title": "خوراک و مایحتاج منزل",
    "expense_or_income": false,
    "person_id": null,
    "is_public": true,
    "created_at": "2025-07-08T11:44:46.298584",
    "updated_at": "2025-07-08T11:44:46.298584"
  },
  {
    "id": 5,
    "title": "پوشاک و لوازم شخصی",
    "expense_or_income": false,
    "person_id": null,
    "is_public": true,
    "created_at": "2025-07-08T11:44:46.298584",
    "updated_at": "2025-07-08T11:44:46.298584"
  },
  {
    "id": 6,
    "title": "بهداشت و درمان",
    "expense_or_income": false,
    "person_id": null,
    "is_public": true,
    "created_at": "2025-07-08T11:44:46.298584",
    "updated_at": "2025-07-08T11:44:46.298584"
  },
  {
    "id": 7,
    "title": "سرگرمی و تفریح",
    "expense_or_income": false,
    "person_id": null,
    "is_public": true,
    "created_at": "2025-07-08T11:44:46.298584",
    "updated_at": "2025-07-08T11:44:46.298584"
  },
  {
    "id": 8,
    "title": "آموزش و توسعه فردی",
    "expense_or_income": false,
    "person_id": null,
    "is_public": true,
    "created_at": "2025-07-08T11:44:46.298584",
    "updated_at": "2025-07-08T11:44:46.298584"
  },
  {
    "id": 9,
    "title": "پس‌انداز و سرمایه‌گذاری",
    "expense_or_income": false,
    "person_id": null,
    "is_public": true,
    "created_at": "2025-07-08T11:44:46.298584",
    "updated_at": "2025-07-08T11:44:46.298584"
  },
  {
    "id": 10,
    "title": "بدهی‌ها و اقساط",
    "expense_or_income": false,
    "person_id": null,
    "is_public": true,
    "created_at": "2025-07-08T11:44:46.298584",
    "updated_at": "2025-07-08T11:44:46.298584"
  },
  {
    "id": 11,
    "title": "هزینه‌های شهرداری و مالیاتی",
    "expense_or_income": false,
    "person_id": null,
    "is_public": true,
    "created_at": "2025-07-08T11:44:46.298584",
    "updated_at": "2025-07-08T11:44:46.298584"
  },
  {
    "id": 12,
    "title": "هزینه‌های متفرقه",
    "expense_or_income": false,
    "person_id": null,
    "is_public": true,
    "created_at": "2025-07-08T11:44:46.298584",
    "updated_at": "2025-07-08T11:44:46.298584"
  }
]
      ''';
}