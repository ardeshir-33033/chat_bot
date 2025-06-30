import 'package:shamsi_date/shamsi_date.dart';

import 'bank_sms_model.dart'; // For Jalali date handling

// Assuming BankSmsModel is defined in a separate, shared file like 'models/bank_sms_model.dart'
// and imported where needed.
// class BankSmsModel { ... } // (Content provided in a previous turn)

class SarmayehSmsParser {
  /// Parse an SMS transaction from Sarmayeh Bank into a BankSmsModel.
  ///
  /// This function expects numerical digits in Western (0-9) format for regex matching.
  /// It removes common invisible control characters from the input text.
  /// It defaults to "برداشت" (withdrawal) and "expense" as per the original Python code.
  ///
  /// Args:
  ///     text (String): The SMS text to parse.
  ///
  /// Returns:
  ///     BankSmsModel: Parsed transaction details if valid, otherwise a model with an error.
  static BankSmsModel parseSarmayehSms(String text) {
    String? bankName = "بانک سرمایه";
    String? accountNumber;
    String? cardNumber; // Not extracted in this parser
    String? transactionType = "برداشت"; // Default as per original Python
    String? expenseOrIncome = "expense"; // Default as per original Python
    int? amountOfTransaction;
    int? balance;
    String? datetime;
    String? merchantName; // Not extracted in this parser
    String? error;

    // Remove invisible control characters
    text = text.replaceAll(RegExp(r'[\u200B-\u200F\uFEFF]'), '');

    // Split and clean lines
    List<String> lines = text.split('\n').map((ln) => ln.trim()).where((ln) => ln.isNotEmpty).toList();

    // Check if there are exactly seven lines
    if (lines.length != 7) {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (expected 7 lines).",
      );
    }

    // Check if the first line is "بانک سرمايه"
    if (lines[0] != "بانک سرمايه") {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (missing 'بانک سرمايه' header).",
      );
    }

    // Extract account_number from third line
    RegExp accountRegex = RegExp(r"برداشت از:(.*)");
    RegExpMatch? accountMatch = accountRegex.firstMatch(lines[2]);
    if (accountMatch != null) {
      accountNumber = accountMatch.group(1)!.trim();
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (account number not found).",
      );
    }

    // Extract amount from fourth line
    RegExp amountRegex = RegExp(r"مبلغ:(.*)");
    RegExpMatch? amountMatch = amountRegex.firstMatch(lines[3]);
    if (amountMatch != null) {
      String amountStr = amountMatch.group(1)!.trim().replaceAll(',', '');
      try {
        amountOfTransaction = int.parse(amountStr);
      } catch (e) {
        print("Error parsing Sarmayeh amount: $e");
        return BankSmsModel(
          bankName: bankName,
          error: "The given SMS is not a valid transaction SMS (amount parsing error).",
        );
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (amount not found).",
      );
    }

    // Extract date from fifth line
    RegExp dateRegex = RegExp(r"تاريخ:(\d{4})/(\d{1,2})/(\d{1,2})");
    RegExpMatch? dateMatch = dateRegex.firstMatch(lines[4]);
    int? year, month, day;
    if (dateMatch != null) {
      try {
        year = int.parse(dateMatch.group(1)!);
        month = int.parse(dateMatch.group(2)!);
        day = int.parse(dateMatch.group(3)!);
      } catch (e) {
        print("Error parsing Sarmayeh date components: $e");
        return BankSmsModel(
          bankName: bankName,
          error: "The given SMS is not a valid transaction SMS (date parsing error).",
        );
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (date not found).",
      );
    }

    // Extract time from sixth line
    RegExp timeRegex = RegExp(r"زمان:(\d{2}):(\d{2})(?::(\d{2}))?"); // Handles HH:MM or HH:MM:SS
    RegExpMatch? timeMatch = timeRegex.firstMatch(lines[5]);
    int? hour, minute, second;
    if (timeMatch != null) {
      try {
        hour = int.parse(timeMatch.group(1)!);
        minute = int.parse(timeMatch.group(2)!);
        second = timeMatch.group(3) != null ? int.parse(timeMatch.group(3)!) : 0; // Default seconds to 0
      } catch (e) {
        print("Error parsing Sarmayeh time components: $e");
        return BankSmsModel(
          bankName: bankName,
          error: "The given SMS is not a valid transaction SMS (time parsing error).",
        );
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (time not found).",
      );
    }

    // Combine date and time into ISO Jalali format, then convert to Gregorian ISO 8601
    if (year != null && month != null && day != null && hour != null && minute != null && second != null) {
      try {
        Jalali jdt = Jalali(year, month, day, hour, minute, second);
        datetime = jdt.toDateTime().toIso8601String();
      } catch (e) {
        print("Error constructing Sarmayeh datetime: $e");
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

    // Extract balance from seventh line
    RegExp balanceRegex = RegExp(r"مانده:(.*)");
    RegExpMatch? balanceMatch = balanceRegex.firstMatch(lines[6]);
    if (balanceMatch != null) {
      String balanceStr = balanceMatch.group(1)!.trim().replaceAll(',', '');
      try {
        balance = int.parse(balanceStr);
      } catch (e) {
        print("Error parsing Sarmayeh balance: $e");
        return BankSmsModel(
          bankName: bankName,
          error: "The given SMS is not a valid transaction SMS (balance parsing error).",
        );
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (balance not found).",
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