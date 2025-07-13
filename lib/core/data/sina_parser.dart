import 'package:shamsi_date/shamsi_date.dart';

import 'bank_sms_model.dart'; // For Jalali date handling

// Assuming BankSmsModel is defined in a separate, shared file like 'models/bank_sms_model.dart'
// and imported where needed.
// class BankSmsModel { ... } // (Content provided in a previous turn)

class SinaSmsParser {
  /// Define month mapping for Jalali calendar, now a static const member.
  static const Map<String, String> _monthMap = {
    "فروردین": "01",
    "اردیبهشت": "02",
    "خرداد": "03",
    "تیر": "04",
    "مرداد": "05",
    "شهریور": "06",
    "مهر": "07",
    "آبان": "08",
    "آذر": "09",
    "دی": "10",
    "بهمن": "11",
    "اسفند": "12",
  };

  /// Parse an SMS transaction from Sina Bank into a BankSmsModel.
  ///
  /// Includes error handling to detect if the SMS is not a valid transaction message.
  /// This function expects numerical digits in Western (0-9) format for regex matching.
  /// It defaults to "برداشت" (withdrawal) and "expense" as per the original Python code.
  ///
  /// Args:
  ///     text (String): The SMS text to parse.
  ///
  /// Returns:
  ///     BankSmsModel: Parsed transaction details if valid, otherwise a model with an error.
  static BankSmsModel parseSinaSms(String text) {
    String? bankName = "بانک سینا";
    String? accountNumber;
    String? cardNumber; // Not extracted in this parser
    String? transactionType = "برداشت"; // Default as per original Python
    String? expenseOrIncome = "expense"; // Default as per original Python
    int? amountOfTransaction;
    int? balance;
    String? datetime;
    String? merchantName; // Not extracted in this parser
    String? error;

    // Check for withdrawal transaction and extract account number
    RegExp accountRegex = RegExp(r"برداشت از (\S+)");
    RegExpMatch? accountMatch = accountRegex.firstMatch(text);
    if (accountMatch != null) {
      accountNumber = accountMatch.group(1);
    } else {
      return BankSmsModel(
        bankName: bankName,
        error:
            "The given SMS is not a valid transaction SMS (account number not found).",
      );
    }

    // Extract amount of transaction
    RegExp amountRegex = RegExp(r"مبلغ  ([\d,]+) ريال");
    RegExpMatch? amountMatch = amountRegex.firstMatch(text);
    if (amountMatch != null) {
      String amountStr = amountMatch.group(1)!.replaceAll(',', '');
      try {
        amountOfTransaction = int.parse(amountStr);
      } catch (e) {
        print("Error parsing Sina amount: $e");
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error:
            "The given SMS is not a valid transaction SMS (amount not found).",
      );
    }

    // Extract remaining balance
    RegExp balanceRegex = RegExp(r"مانده ([\d,]+) ريال");
    RegExpMatch? balanceMatch = balanceRegex.firstMatch(text);
    if (balanceMatch != null) {
      String balanceStr = balanceMatch.group(1)!.replaceAll(',', '');
      try {
        balance = int.parse(balanceStr);
      } catch (e) {
        print("Error parsing Sina balance: $e");
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error:
            "The given SMS is not a valid transaction SMS (balance not found).",
      );
    }

    // Extract datetime components
    // Format: زمان : DAY MONTH_NAME ماه YEAR ; HH:MM:SS
    RegExp datetimeRegex = RegExp(
      r"زمان : (\d+) (\S+) ماه (\d+) ; (\d{2}):(\d{2}):(\d{2})",
    );
    RegExpMatch? datetimeMatch = datetimeRegex.firstMatch(text);
    if (datetimeMatch != null) {
      try {
        int dayNum = int.parse(datetimeMatch.group(1)!);
        String monthName = datetimeMatch.group(2)!;
        int yearNum = int.parse(datetimeMatch.group(3)!);
        int hour = int.parse(datetimeMatch.group(4)!);
        int minute = int.parse(datetimeMatch.group(5)!);
        int second = int.parse(datetimeMatch.group(6)!);

        String? monthStr = _monthMap[monthName];
        if (monthStr == null) {
          return BankSmsModel(
            bankName: bankName,
            error: "Invalid month name in SMS: $monthName.",
          );
        }
        int monthNum = int.parse(monthStr);

        // Convert parsed Jalali components to Gregorian ISO 8601
        Jalali jdt = Jalali(yearNum, monthNum, dayNum, hour, minute, second);
        datetime = jdt.toDateTime().toIso8601String();
      } catch (e) {
        print("Error parsing Sina datetime components: $e");
        return BankSmsModel(
          bankName: bankName,
          error:
              "The given SMS is not a valid transaction SMS (datetime parsing error).",
        );
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error:
            "The given SMS is not a valid transaction SMS (datetime not found).",
      );
    }

    // Since the original Python code directly returns `result` at this point,
    // it implies that if parsing reached here, all essential fields were successfully populated.
    return BankSmsModel(
      bankName: bankName,
      accountNumber: accountNumber,
      cardNumber: cardNumber,
      transactionType: transactionType,
      expenseOrIncome: expenseOrIncome,
      amountOfTransaction: amountOfTransaction,
      balance: balance,
      datetime: datetime,
      merchantName: merchantName,
      error: null,
    );
  }
}
