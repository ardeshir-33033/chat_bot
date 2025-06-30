import 'package:shamsi_date/shamsi_date.dart';

import 'bank_sms_model.dart'; // Ensure this package is in your pubspec.yaml

// Assuming BankSmsModel is defined in a separate, shared file like 'models/bank_sms_model.dart'
// and imported where needed.
// class BankSmsModel { ... } // (Content provided in a previous turn)

class MelliSmsParser {
  /// Parses an SMS text from Melli Bank and returns a BankSmsModel.
  ///
  /// This function expects numerical digits in Western (0-9) format for regex matching.
  static BankSmsModel parseMelliSms(String text) {
    String? accountNumber;
    String? cardNumber; // Not explicitly extracted in Melli parser
    String? transactionType;
    String? expenseOrIncome;
    int? amountOfTransaction;
    int? balance;
    String? datetime;
    String? merchantName; // Not explicitly extracted in Melli parser
    String? error;

    // Split and clean lines
    List<String> lines = text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    // Check if the SMS starts with Bank Melli's name
    if (lines.isEmpty || lines[0] != "بانك ملي ايران") {
      return BankSmsModel(
        bankName: "بانک ملی",
        error: "The given SMS is not a valid transaction SMS for Melli Bank (header mismatch).",
      );
    }

    // Try parsing standard transaction format
    for (String line in lines.skip(1)) {
      // Transaction type and amount (e.g., انتقال:1,000,360-)
      // Group 1: transaction type, Group 2: amount, Group 3: sign
      RegExp transactionAmountRegex = RegExp(r"^(.*?):\s*([\d,]+)([+-])$");
      RegExpMatch? match = transactionAmountRegex.firstMatch(line);
      if (match != null) {
        transactionType = match.group(1)!.trim();
        String amountStr = match.group(2)!.replaceAll(',', '');
        try {
          amountOfTransaction = int.parse(amountStr);
        } catch (e) {
          print("Error parsing Melli amount: $e");
        }
        String sign = match.group(3)!;
        expenseOrIncome = (sign == "+") ? "income" : "expense";
        continue;
      }

      // Account number (e.g., حساب:18003)
      RegExp accountNumberRegex = RegExp(r"حساب:(\d+)");
      match = accountNumberRegex.firstMatch(line);
      if (match != null) {
        accountNumber = match.group(1);
        continue;
      }

      // Balance (e.g., مانده:9,813,700)
      RegExp balanceRegex = RegExp(r"مانده:([\d,]+)");
      match = balanceRegex.firstMatch(line);
      if (match != null) {
        String balanceStr = match.group(1)!.replaceAll(',', '');
        try {
          balance = int.parse(balanceStr);
        } catch (e) {
          print("Error parsing Melli balance: $e");
        }
        continue;
      }

      // Datetime (e.g., 0210-12:02 as MMDD-HH:MM)
      // Group 1: month, Group 2: day, Group 3: hour, Group 4: minute
      RegExp datetimeRegex = RegExp(r"(\d{2})(\d{2})-(\d{2}):(\d{2})");
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
          print("Error parsing Melli datetime: $e");
        }
        continue;
      }
    }

    // Check if standard transaction fields are present
    if (amountOfTransaction != null && accountNumber != null) {
      return BankSmsModel(
        bankName: "بانک ملی",
        accountNumber: accountNumber,
        cardNumber: cardNumber,
        transactionType: transactionType,
        expenseOrIncome: expenseOrIncome,
        amountOfTransaction: amountOfTransaction,
        balance: balance,
        datetime: datetime,
        merchantName: merchantName,
        error: null, // No error if standard fields found
      );
    }

    // If standard format not matched, try parsing special fee deduction format
    for (String line in lines.skip(1)) {
      // Special case (e.g., به مبلغ:92240از حساب:0360938518003)
      // Group 1: amount, Group 2: account number
      RegExp feeDeductionRegex = RegExp(r"به مبلغ:(\d+)از حساب:(\d+)");
      RegExpMatch? match = feeDeductionRegex.firstMatch(line);
      if (match != null) {
        try {
          amountOfTransaction = int.parse(match.group(1)!);
        } catch (e) {
          print("Error parsing Melli fee amount: $e");
        }
        accountNumber = match.group(2);
        transactionType = "برداشت"; // Treat as withdrawal
        expenseOrIncome = "expense";
        // Balance and datetime remain null as they’re not provided in this format
        return BankSmsModel(
          bankName: "بانک ملی",
          accountNumber: accountNumber,
          cardNumber: cardNumber,
          transactionType: transactionType,
          expenseOrIncome: expenseOrIncome,
          amountOfTransaction: amountOfTransaction,
          balance: balance, // Will be null
          datetime: datetime, // Will be null
          merchantName: merchantName,
          error: null, // No error if fee deduction format found
        );
      }
    }

    // If neither format matches, return error
    return BankSmsModel(
      bankName: "بانک ملی",
      error: "The given SMS is not a valid transaction SMS.",
    );
  }
}