import 'package:shamsi_date/shamsi_date.dart';

import 'bank_sms_model.dart'; // For Jalali date handling

// Assuming BankSmsModel is defined in a separate, shared file like 'models/bank_sms_model.dart'
// and imported where needed.
// class BankSmsModel { ... } // (Content provided in a previous turn)

class ParsianSmsParser {
  /// Parse an SMS transaction from Parsian Bank into a BankSmsModel.
  ///
  /// This function expects numerical digits in Western (0-9) format for regex matching.
  /// It removes common invisible control characters from the input text.
  /// The year for the transaction datetime is hardcoded to 1402 (Jalali).
  ///
  /// Args:
  ///     text (String): The SMS text to parse.
  ///
  /// Returns:
  ///     BankSmsModel: Parsed transaction details if valid, otherwise a model with an error.
  static BankSmsModel parseParsianSms(String text) {
    String? bankName = "بانک پارسیان";
    String? accountNumber;
    String? cardNumber; // Not extracted in this parser
    String? transactionType;
    String? expenseOrIncome;
    int? amountOfTransaction;
    int? balance;
    String? datetime;
    String? merchantName; // Not extracted in this parser
    String? error;

    // Remove invisible control characters for robustness
    // Equivalent of Python's unicodedata.category(c) != 'Cf' for common format control characters
    text = text.replaceAll(RegExp(r'[\u200B-\u200F\uFEFF]'), '');

    // Split and clean lines
    List<String> lines = text.split('\n').map((ln) => ln.trim()).where((ln) => ln.isNotEmpty).toList();

    // Check if there are exactly five lines as per valid transaction format
    if (lines.length != 5) {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (expected 5 lines).",
      );
    }

    // Check if the first line is numeric (assumed account number)
    if (!RegExp(r'^\d+$').hasMatch(lines[0])) {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (first line is not an account number).",
      );
    }
    accountNumber = lines[0];

    // Extract amount and sign from second line
    RegExp amountSignRegex = RegExp(r"مبلغ:([\d,]+)([-+])");
    RegExpMatch? amountSignMatch = amountSignRegex.firstMatch(lines[1]);
    if (amountSignMatch != null) {
      String amountStr = amountSignMatch.group(1)!.replaceAll(',', '');
      String sign = amountSignMatch.group(2)!;
      try {
        amountOfTransaction = int.parse(amountStr);
      } catch (e) {
        print("Error parsing Parsian amount: $e");
      }

      if (sign == '-') {
        expenseOrIncome = "expense";
        transactionType = "برداشت"; // Withdrawal
      } else if (sign == '+') {
        expenseOrIncome = "income";
        transactionType = "واریز"; // Deposit
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (amount or sign not found).",
      );
    }

    // Extract balance from third line
    RegExp balanceRegex = RegExp(r"مانده:([\d,]+)");
    RegExpMatch? balanceMatch = balanceRegex.firstMatch(lines[2]);
    if (balanceMatch != null) {
      String balanceStr = balanceMatch.group(1)!.replaceAll(',', '');
      try {
        balance = int.parse(balanceStr);
      } catch (e) {
        print("Error parsing Parsian balance: $e");
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (balance not found).",
      );
    }

    // Extract date from fourth line (MM/DD)
    RegExp dateRegex = RegExp(r"(\d{2})/(\d{2})");
    RegExpMatch? dateMatch = dateRegex.firstMatch(lines[3]);
    int? month, day;
    if (dateMatch != null) {
      try {
        month = int.parse(dateMatch.group(1)!);
        day = int.parse(dateMatch.group(2)!);
      } catch (e) {
        print("Error parsing Parsian date components: $e");
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (date not found).",
      );
    }

    // Extract time from fifth line (HH:MM)
    RegExp timeRegex = RegExp(r"(\d{2}):(\d{2})");
    RegExpMatch? timeMatch = timeRegex.firstMatch(lines[4]);
    int? hour, minute;
    if (timeMatch != null) {
      try {
        hour = int.parse(timeMatch.group(1)!);
        minute = int.parse(timeMatch.group(2)!);
      } catch (e) {
        print("Error parsing Parsian time components: $e");
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (time not found).",
      );
    }

    // Construct datetime assuming year 1402 (Jalali calendar)
    // Then convert to Gregorian ISO 8601 string
    if (month != null && day != null && hour != null && minute != null) {
      try {
        int jalaliYear = 1402; // Hardcoded as per original Python logic
        Jalali jdt = Jalali(jalaliYear, month, day, hour, minute, 0); // Seconds are 0
        datetime = jdt.toDateTime().toIso8601String();
      } catch (e) {
        print("Error constructing Parsian datetime: $e");
        return BankSmsModel(
          bankName: bankName,
          error: "The given SMS is not a valid transaction SMS (datetime construction error).",
        );
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (incomplete datetime components).",
      );
    }

    // If all essential fields are parsed, return the model.
    if (accountNumber != null &&
        amountOfTransaction != null &&
        balance != null &&
        datetime != null &&
        transactionType != null &&
        expenseOrIncome != null) {
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

    // Fallback error if any critical field is still null
    return BankSmsModel(
      bankName: bankName,
      error: "The given SMS is not a valid transaction SMS (missing essential parsed fields).",
    );
  }
}