typedef AnswerProcessor = Future<bool> Function(dynamic answer);

class QuestionsApiData {
  static int totalSteps = 3;
  static List<int> stepsTotalOrders = [6, 4, 2];

  QuestionType getQuestionTypeFromSystemName(String systemName) {
    const yesNoNames = {'has_fix_income', 'has_expense_categories'};
    const multiSelectNames = {
      "user_goal",
      "fix_income_type",
      "most_recent_categories",
      "debt",
    };
    const singleSelectNames = {
      "most_expense_categories",
      "sms_bank_permission",
    };
    const textNames = {"income_amount"};
    const selectAndTypeNames = {"fix_income_list", "expense_categories"};

    if (yesNoNames.contains(systemName)) return QuestionType.yesNo;
    if (multiSelectNames.contains(systemName)) return QuestionType.multiSelect;
    if (singleSelectNames.contains(systemName))
      return QuestionType.singleSelect;
    if (textNames.contains(systemName)) return QuestionType.text;
    if (selectAndTypeNames.contains(systemName))
      return QuestionType.selectAndType;

    throw Exception('Unknown system name: $systemName');
  }

  final banks = [
    {
      "id": 1,
      "bank_name": "ملی ایران",
      "logo": "assets/images/banks/meli-bank-logo--10677.svg",
    },
    {
      "id": 2,
      "bank_name": "سپه",
      "logo": "assets/images/banks/sepah-bank-logo--10686.svg",
    },
    {
      "id": 3,
      "bank_name": "ملت",
      "logo": "assets/images/banks/melat-bank-logo--10680.svg",
    },
    {"id": 4, "bank_name": "صادرات ایران", "logo": ""},
    {"id": 5, "bank_name": "تجارت", "logo": ""},
    {
      "id": 6,
      "bank_name": "کشاورزی",
      "logo": "assets/images/banks/keshavarzi-bank-logo--10688.svg",
    },
    {
      "id": 7,
      "bank_name": "پست بانک",
      "logo": "assets/images/banks/post-bank-logo--10697.svg",
    },
    {
      "id": 8,
      "bank_name": "آینده",
      "logo": "assets/images/banks/ayandeh-bank-logo--10693.svg",
    },
    {
      "id": 9,
      "bank_name": "کارآفرین",
      "logo": "assets/images/banks/karafarin-bank-logo--10696.svg",
    },
    {
      "id": 10,
      "bank_name": "پارسیان",
      "logo": "assets/images/banks/parsian-bank-logo--10695.svg",
    },
    {
      "id": 11,
      "bank_name": "سینا",
      "logo": "assets/images/banks/sina-bank-logo--10694.svg",
    },
    {
      "id": 12,
      "bank_name": "دی",
      "logo": "assets/images/banks/dey-bank-logo--10715.svg",
    },
    {
      "id": 13,
      "bank_name": "مهر اقتصاد",
      "logo": "assets/images/banks/mehr-eghtesad-bank-logo--10701.svg",
    },
    {
      "id": 14,
      "bank_name": "قوامین",
      "logo": "assets/images/banks/ghavamin-bank-logo--10703.svg",
    },
    {"id": 15, "bank_name": "توسعه تعاون", "logo": ""},
    {"id": 16, "bank_name": "سرمایه", "logo": ""},
    {
      "id": 17,
      "bank_name": "خاورمیانه",
      "logo": "assets/images/banks/khavarmianeh-bank-logo--10711.svg",
    },
    {"id": 18, "bank_name": "اقتصاد نوین", "logo": ""},
    {
      "id": 19,
      "bank_name": "پاسارگاد",
      "logo": "assets/images/banks/pasargad-bank-logo--10704.svg",
    },
    {
      "id": 20,
      "bank_name": "سامان",
      "logo": "assets/images/banks/saman-bank-logo--10684.svg",
    },
    {"id": 21, "bank_name": "رفاه کارگران", "logo": ""},
    {
      "id": 22,
      "bank_name": "شهر",
      "logo": "assets/images/banks/shahr-bank-logo--10698.svg",
    },
    {
      "id": 23,
      "bank_name": "صنعت و معدن",
      "logo": "assets/images/banks/sanat-madan-bank-logo--10707.svg",
    },
  ];
}

enum QuestionType {
  yesNo,
  multiSelect,
  singleSelect,
  text,
  selectAndType,
  bankAccounts,
}
