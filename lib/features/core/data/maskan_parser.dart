import 'package:shamsi_date/shamsi_date.dart';

import 'bank_sms_model.dart'; // Ensure this package is in your pubspec.yaml

// Assuming BankSmsModel is defined in a separate, shared file like 'models/bank_sms_model.dart'
// and imported where needed.
// class BankSmsModel { ... } // (Content provided in a previous turn)

class MaskanSmsParser {
  /// Parses an SMS text from Maskan Bank and returns a BankSmsModel.
  ///
  /// This function expects numerical digits in Western (0-9) format for regex matching.
  /// It handles and removes specific Unicode control characters (LRM, RLM).
  static BankSmsModel parseMaskanSms(String text) {
    String? accountNumber;
    String? cardNumber;
    String? transactionType;
    String? expenseOrIncome;
    int? amountOfTransaction;
    int? balance;
    String? datetime;
    String? merchantName;
    String? error;

    // Split and clean lines
    List<String> lines = text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    List<String> unmatchedLines = [];

    for (String line in lines) {
      // Check for datetime (MMDD-hh:mm)
      RegExp datetimeRegex = RegExp(r'^(\d{2})(\d{2})-(\d{2}):(\d{2})$');
      RegExpMatch? mDatetime = datetimeRegex.firstMatch(line);
      if (mDatetime != null) {
        try {
          int month = int.parse(mDatetime.group(1)!);
          int day = int.parse(mDatetime.group(2)!);
          int hour = int.parse(mDatetime.group(3)!);
          int minute = int.parse(mDatetime.group(4)!);

          // Get current Jalali year
          Jalali now = Jalali.now();
          int jy = now.year;

          // Construct Jalali date
          Jalali transactionJalaliDate = Jalali(jy, month, day, hour, minute, 0);

          // Convert to Gregorian and then to ISO 8601 string
          datetime = transactionJalaliDate.toDateTime().toIso8601String();
        } catch (e) {
          print("Error parsing Maskan datetime: $e");
          // Continue to next line, datetime will remain null
        }
        continue;
      }

      // Check for account number
      RegExp accountNumberRegex = RegExp(r'حساب:(\d+)');
      RegExpMatch? mAccount = accountNumberRegex.firstMatch(line);
      if (mAccount != null) {
        accountNumber = mAccount.group(1);
        continue;
      }

      // Check for card number
      RegExp cardNumberRegex = RegExp(r'کارت:(\d+)');
      RegExpMatch? mCard = cardNumberRegex.firstMatch(line);
      if (mCard != null) {
        cardNumber = mCard.group(1);
        continue;
      }

      // Check for balance
      RegExp balanceRegex = RegExp(r'مانده:([\d,]+)');
      RegExpMatch? mBalance = balanceRegex.firstMatch(line);
      if (mBalance != null) {
        try {
          balance = int.parse(mBalance.group(1)!.replaceAll(',', ''));
        } catch (e) {
          print("Error parsing Maskan balance: $e");
          // Continue to next line, balance will remain null
        }
        continue;
      }

      // Check for transaction type and amount
      // Remove LRM (U+200E) and RLM (U+200F) characters from the line
      String cleanedLine = line.replaceAll(RegExp(r'[\u200E\u200F]'), '');
      // Python's named groups (type, sign, amt) map to positional groups in Dart
      // group(1): type, group(2): sign, group(3): amount
      RegExp transactionAmountRegex = RegExp(r'^([^:]+):([+-])([\d,]+)$');
      RegExpMatch? mTransaction = transactionAmountRegex.firstMatch(cleanedLine);
      if (mTransaction != null) {
        transactionType = mTransaction.group(1)!.trim();
        String sign = mTransaction.group(2)!;
        try {
          amountOfTransaction = int.parse(mTransaction.group(3)!.replaceAll(',', ''));
          expenseOrIncome = (sign == '+') ? "income" : "expense";
        } catch (e) {
          print("Error parsing Maskan amount: $e");
          // Continue to next line, amount and expense_or_income will remain null
        }
        continue;
      }

      // Collect unmatched lines (potential merchant name)
      unmatchedLines.add(line);
    }

    // Extract merchant name for purchase transactions, if transaction type is "خرید"
    // and there are unmatched lines, use the first unmatched line as merchant name.
    if (transactionType == "خرید" && unmatchedLines.isNotEmpty) {
      merchantName = unmatchedLines[0];
    }

    // Final validity checking: if essential fields are missing, it’s not a valid transaction SMS.
    // The Python logic checks if all fields *except* bank_name are null.
    // We will check for amount, datetime, and transactionType as critical indicators.
    if (amountOfTransaction == null || datetime == null || transactionType == null) {
      error = "The given SMS is not a valid transaction SMS.";
    }

    return BankSmsModel(
      bankName: "بانک مسکن",
      accountNumber: accountNumber,
      cardNumber: cardNumber,
      transactionType: transactionType,
      expenseOrIncome: expenseOrIncome,
      amountOfTransaction: amountOfTransaction,
      balance: balance,
      datetime: datetime,
      merchantName: merchantName,
      error: error,
    );
  }
}