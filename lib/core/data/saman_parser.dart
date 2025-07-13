import 'package:shamsi_date/shamsi_date.dart';

import 'bank_sms_model.dart'; // For Jalali date handling

// Assuming BankSmsModel is defined in a separate, shared file like 'models/bank_sms_model.dart'
// and imported where needed.
// class BankSmsModel { ... } // (Content provided in a previous turn)

class SamanSmsParser {
  /// Parse an SMS transaction from Saman Bank into a BankSmsModel.
  ///
  /// Includes error handling to detect if the SMS is not a valid transaction message.
  /// This function expects numerical digits in Western (0-9) format for regex matching.
  ///
  /// Args:
  ///     text (String): The SMS text to parse.
  ///
  /// Returns:
  ///     BankSmsModel: Parsed transaction details if valid, otherwise a model with an error.
  static BankSmsModel parseSamanSms(String text) {
    String? bankName = "بانک سامان";
    String? accountNumber;
    String? cardNumber; // Not extracted in this parser
    String? transactionType;
    String? expenseOrIncome = "expense"; // Default to expense as per original Python
    int? amountOfTransaction;
    int? balance;
    String? datetime;
    String? merchantName; // Not extracted in this parser by the original Python code
    String? error;

    // Check if SMS is a valid transaction (contains "برداشت مبلغ" and no "رمز")
    if (!text.contains("برداشت مبلغ") || text.contains("رمز")) {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS.",
      );
    }

    // Extract amount and transaction type
    // Note: Python's `(.+?)\n` means non-greedy match up to newline.
    // Dart's `RegExp` handles `.` as any character (except newline by default), and `*?` for non-greedy.
    // We expect the transaction type to be on the same line as "برداشت مبلغ".
    RegExp transactionRegex = RegExp(r"برداشت مبلغ ([\d,]+) (.+?)(?:\s|$|\n)");
    RegExpMatch? transactionMatch = transactionRegex.firstMatch(text);
    if (transactionMatch != null) {
      String amountStr = transactionMatch.group(1)!.replaceAll(',', '');
      try {
        amountOfTransaction = int.parse(amountStr);
      } catch (e) {
        print("Error parsing Saman amount: $e");
      }
      transactionType = transactionMatch.group(2)!.trim();
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (amount/transaction type not found).",
      );
    }

    // Extract account number
    RegExp accountRegex = RegExp(r"از ‪(.+?)‬"); // Note the specific unicode characters (persian alef)
    RegExpMatch? accountMatch = accountRegex.firstMatch(text);
    if (accountMatch != null) {
      accountNumber = accountMatch.group(1);
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (account number not found).",
      );
    }

    // Extract balance
    RegExp balanceRegex = RegExp(r"مانده ([\d,]+)");
    RegExpMatch? balanceMatch = balanceRegex.firstMatch(text);
    if (balanceMatch != null) {
      String balanceStr = balanceMatch.group(1)!.replaceAll(',', '');
      try {
        balance = int.parse(balanceStr);
      } catch (e) {
        print("Error parsing Saman balance: $e");
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (balance not found).",
      );
    }

    // Extract date and time
    RegExp datePattern = RegExp(r"(\d{4})/(\d{1,2})/(\d{1,2})");
    RegExp timePattern = RegExp(r"(\d{2}):(\d{2}):(\d{2})");

    RegExpMatch? dateMatch = datePattern.firstMatch(text);
    RegExpMatch? timeMatch = timePattern.firstMatch(text);

    if (dateMatch != null && timeMatch != null) {
      try {
        int year = int.parse(dateMatch.group(1)!);
        int month = int.parse(dateMatch.group(2)!);
        int day = int.parse(dateMatch.group(3)!);

        int hour = int.parse(timeMatch.group(1)!);
        int minute = int.parse(timeMatch.group(2)!);
        int second = int.parse(timeMatch.group(3)!);

        // Assuming extracted date components are Jalali, convert to Gregorian ISO 8601
        Jalali jdt = Jalali(year, month, day, hour, minute, second);
        datetime = jdt.toDateTime().toIso8601String();
      } catch (e) {
        print("Error parsing Saman datetime components: $e");
        return BankSmsModel(
          bankName: bankName,
          error: "The given SMS is not a valid transaction SMS (datetime parsing error).",
        );
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (date or time not found).",
      );
    }

    // Since the initial check ensures "برداشت مبلغ" is present,
    // transactionType and expenseOrIncome should be set correctly if parsing reaches here.
    // The original Python code directly returns `result` at this point without a final check for `None` values,
    // implying that if it reached here, all essential fields were populated by previous checks.
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