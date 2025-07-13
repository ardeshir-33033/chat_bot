import 'package:shamsi_date/shamsi_date.dart';

import 'bank_sms_model.dart'; // Ensure this package is in your pubspec.yaml

// Assuming BankSmsModel is defined in a separate, shared file like 'models/bank_sms_model.dart'
// and imported where needed.
// class BankSmsModel { ... } // (Content provided in a previous turn)

class SaderatSmsParser {
  /// Parses an SMS text from Saderat Bank and returns a BankSmsModel.
  ///
  /// This function expects numerical digits in Western (0-9) format for regex matching.
  /// It converts extracted Jalali dates to ISO 8601 Gregorian strings.
  static BankSmsModel parseSaderatSms(String text) {
    String? bankName = "بانک صادرات";
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
      // Skip bank name line if present
      if (line == "بانک صادرات") {
        continue;
      }

      // Check for transaction type and amount (e.g., برداشت: 50,000-)
      // Group 1: transaction type, Group 2: amount, Group 3: sign
      RegExp transactionAmountRegex = RegExp(r"^(.*?):\s*([\d,]+)([+-])$");
      RegExpMatch? match = transactionAmountRegex.firstMatch(line);
      if (match != null) {
        transactionType = match.group(1)!.trim();
        String amountStr = match.group(2)!.replaceAll(',', '');
        try {
          amountOfTransaction = int.parse(amountStr);
        } catch (e) {
          print("Error parsing Saderat amount: $e");
        }
        String sign = match.group(3)!;
        expenseOrIncome = (sign == "+") ? "income" : "expense";
        continue;
      }

      // Check for account number (e.g., حساب:123456789)
      RegExp accountNumberRegex = RegExp(r"حساب:(\d+)");
      match = accountNumberRegex.firstMatch(line);
      if (match != null) {
        accountNumber = match.group(1);
        continue;
      }

      // Check for balance (e.g., مانده:1,000,000)
      RegExp balanceRegex = RegExp(r"مانده:([\d,]+)");
      match = balanceRegex.firstMatch(line);
      if (match != null) {
        String balanceStr = match.group(1)!.replaceAll(',', '');
        try {
          balance = int.parse(balanceStr);
        } catch (e) {
          print("Error parsing Saderat balance: $e");
        }
        continue;
      }

      // Check for card number (e.g., کارت:1234)
      RegExp cardNumberRegex = RegExp(r"کارت:(\d+)");
      match = cardNumberRegex.firstMatch(line);
      if (match != null) {
        cardNumber = match.group(1);
        continue;
      }

      // Check for merchant name (e.g., از:فروشگاه XYZ) for purchase/payment
      // Note: This logic depends on transactionType being already set.
      if ((transactionType == "خرید" || transactionType == "پرداخت") &&
          line.contains("از:")) {
        merchantName = line.split("از:")[1].trim();
        continue;
      }

      // Check for datetime (e.g., 1225 - 14:30) (MMDD - HH:MM)
      // Group 1: month, Group 2: day, Group 3: hour, Group 4: minute
      RegExp datetimeRegex = RegExp(r"(\d{2})(\d{2})\s*-\s*(\d{2}):(\d{2})");
      match = datetimeRegex.firstMatch(line);
      if (match != null) {
        try {
          int month = int.parse(match.group(1)!);
          int day = int.parse(match.group(2)!);
          int hour = int.parse(match.group(3)!);
          int minute = int.parse(match.group(4)!);

          Jalali now = Jalali.now();
          int jy = now.year; // Assume current Jalali year

          Jalali transactionJalaliDate = Jalali(jy, month, day, hour, minute, 0);
          datetime = transactionJalaliDate.toDateTime().toIso8601String();
        } catch (e) {
          print("Error parsing Saderat datetime: $e");
        }
        continue;
      }

      // Check for amount without prefix (e.g., 1,000,000)
      // This is a fallback if the amount isn't captured by the first regex
      RegExp rawAmountRegex = RegExp(r'^[\d,]+$');
      if (rawAmountRegex.hasMatch(line) && amountOfTransaction == null) {
        String amountStr = line.replaceAll(',', '');
        try {
          amountOfTransaction = int.parse(amountStr);
        } catch (e) {
          print("Error parsing Saderat raw amount: $e");
        }
        // We can't determine expense/income or transaction type from this line alone,
        // so those fields would remain null unless inferred elsewhere.
        continue;
      }

      // Collect unmatched lines
      unmatchedLines.add(line);
    }

    // Infer merchant name for purchase/payment if not set and unmatched lines exist
    // This logic relies on `transactionType` being set earlier.
    if ((transactionType == "خرید" || transactionType == "پرداخت") &&
        merchantName == null &&
        unmatchedLines.isNotEmpty) {
      merchantName = unmatchedLines[0]; // Assuming the first unmatched line is the merchant name
    }

    // Final validity checking: if essential fields are missing, it’s not a valid transaction SMS.
    // The Python logic checks if all fields *except* bank_name are null.
    // We will check for amount and datetime as critical indicators. Account number is also important.
    bool isValid = (amountOfTransaction != null && datetime != null && accountNumber != null);

    if (!isValid) {
      error = "The given SMS is not a valid transaction SMS.";
    }

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
      error: error,
    );
  }
}