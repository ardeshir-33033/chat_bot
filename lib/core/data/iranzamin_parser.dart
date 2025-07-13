import 'package:shamsi_date/shamsi_date.dart';

import 'bank_sms_model.dart'; // For Jalali date handling

// Assuming BankSmsModel is defined in a separate, shared file like 'models/bank_sms_model.dart'
// and imported where needed.
// class BankSmsModel { ... } // (Content provided in a previous turn)

class IranZaminSmsParser {
  /// Parse an SMS transaction from Iran Zamin Bank into a BankSmsModel.
  ///
  /// This function expects numerical digits in Western (0-9) format for regex matching.
  /// It includes handling for removing common invisible control characters from account numbers.
  ///
  /// Args:
  ///     text (String): The SMS text to parse.
  ///
  /// Returns:
  ///     BankSmsModel: Parsed transaction details if valid, otherwise a model with an error.
  static BankSmsModel parseIranZaminSms(String text) {
    String? bankName = "بانک ایران زمین";
    String? accountNumber;
    String? cardNumber; // Not extracted in this parser
    String? transactionType;
    String? expenseOrIncome;
    int? amountOfTransaction;
    int? balance;
    String? datetime;
    String? merchantName; // Not extracted in this parser
    String? error;

    // Split and clean lines
    List<String> lines = text.split('\n').map((ln) => ln.trim()).where((ln) => ln.isNotEmpty).toList();

    // Check if there are exactly four lines as per Python logic
    if (lines.length != 4) {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (expected 4 lines).",
      );
    }

    // Extract and clean account number from first line
    accountNumber = lines[0];
    // Equivalent of Python's unicodedata.category(c) != 'Cf' for common format control characters
    // This removes Zero Width Space, Left-to-Right Mark, Right-to-Left Mark, Zero Width Non-Joiner, Zero Width Joiner, and Byte Order Mark
    accountNumber = accountNumber!.replaceAll(RegExp(r'[\u200B-\u200F\uFEFF]'), '');

    // Extract amount and sign from second line
    RegExp amountSignRegex = RegExp(r"مبلغ ([\d,]+)([-+])");
    RegExpMatch? amountSignMatch = amountSignRegex.firstMatch(lines[1]);
    if (amountSignMatch != null) {
      String amountStr = amountSignMatch.group(1)!.replaceAll(',', '');
      String sign = amountSignMatch.group(2)!;
      try {
        amountOfTransaction = int.parse(amountStr);
      } catch (e) {
        print("Error parsing Iran Zamin amount: $e");
      }

      if (sign == '-') {
        expenseOrIncome = "expense";
        transactionType = "برداشت";
      } else if (sign == '+') {
        expenseOrIncome = "income";
        transactionType = "واریز";
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (amount or sign not found).",
      );
    }

    // Extract datetime from third line
    // Format: YYYY/M/D-HH:MM or YYYY/MM/DD-HH:MM
    RegExp datetimeRegex = RegExp(r"(\d{4})/(\d{1,2})/(\d{1,2})-(\d{2}):(\d{2})");
    RegExpMatch? datetimeMatch = datetimeRegex.firstMatch(lines[2]);
    if (datetimeMatch != null) {
      try {
        int year = int.parse(datetimeMatch.group(1)!);
        int month = int.parse(datetimeMatch.group(2)!);
        int day = int.parse(datetimeMatch.group(3)!);
        int hour = int.parse(datetimeMatch.group(4)!);
        int minute = int.parse(datetimeMatch.group(5)!);

        // Ensure month and day are two digits (zfill equivalent)
        // Not strictly necessary for Jalali constructor but good for consistency.
        // String formattedMonth = month.toString().padLeft(2, '0');
        // String formattedDay = day.toString().padLeft(2, '0');

        // Convert parsed Jalali components to Gregorian ISO 8601
        Jalali jdt = Jalali(year, month, day, hour, minute, 0); // Seconds are 0
        datetime = jdt.toDateTime().toIso8601String();
      } catch (e) {
        print("Error parsing Iran Zamin datetime components: $e");
        return BankSmsModel(
          bankName: bankName,
          error: "The given SMS is not a valid transaction SMS (datetime parsing error).",
        );
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (datetime not found).",
      );
    }

    // Extract balance from fourth line
    RegExp balanceRegex = RegExp(r"مانده ([\d,]+)");
    RegExpMatch? balanceMatch = balanceRegex.firstMatch(lines[3]);
    if (balanceMatch != null) {
      String balanceStr = balanceMatch.group(1)!.replaceAll(',', '');
      try {
        balance = int.parse(balanceStr);
      } catch (e) {
        print("Error parsing Iran Zamin balance: $e");
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (balance not found).",
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