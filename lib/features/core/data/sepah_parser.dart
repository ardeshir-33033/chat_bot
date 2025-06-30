import 'package:shamsi_date/shamsi_date.dart';

import 'bank_sms_model.dart'; // For Jalali date handling

// Assuming BankSmsModel is defined in a separate, shared file like 'models/bank_sms_model.dart'
// and imported where needed.
// class BankSmsModel { ... } // (Content provided in a previous turn)

class SepahSmsParser {
  /// Parse an SMS transaction from Sepah Bank into a BankSmsModel.
  ///
  /// Includes error handling to detect if the SMS is not a valid transaction message.
  /// This function expects numerical digits in Western (0-9) format for regex matching.
  ///
  /// Args:
  ///     text (String): The SMS text to parse.
  ///
  /// Returns:
  ///     BankSmsModel: Parsed transaction details if valid, otherwise a model with an error.
  static BankSmsModel parseSepahSms(String text) {
    String? bankName = "بانک سپه";
    String? accountNumber;
    String? cardNumber; // Not extracted in this parser
    String? transactionType;
    String? expenseOrIncome;
    int? amountOfTransaction;
    int? balance;
    String? datetime;
    String? merchantName;
    String? error;

    // Check for non-transaction SMS
    if (text.contains("ورود به همراه بانک") || text.contains("دریافت قسط تسهیلات")) {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS.",
      );
    }

    // Extract account number
    RegExp accountRegex = RegExp(r"از:\s*(\d+)");
    RegExpMatch? accountMatch = accountRegex.firstMatch(text);
    if (accountMatch != null) {
      accountNumber = accountMatch.group(1);
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (account number not found).",
      );
    }

    // Extract amount
    RegExp amountRegex = RegExp(r"مبلغ:\s*([\d,]+)\s*ريال");
    RegExpMatch? amountMatch = amountRegex.firstMatch(text);
    if (amountMatch != null) {
      String amountStr = amountMatch.group(1)!.replaceAll(',', '');
      try {
        amountOfTransaction = int.parse(amountStr);
      } catch (e) {
        print("Error parsing Sepah amount: $e");
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (amount not found).",
      );
    }

    // Extract balance
    RegExp balanceRegex = RegExp(r"موجودي:\s*([\d,]+)\s*ريال");
    RegExpMatch? balanceMatch = balanceRegex.firstMatch(text);
    if (balanceMatch != null) {
      String balanceStr = balanceMatch.group(1)!.replaceAll(',', '');
      try {
        balance = int.parse(balanceStr);
      } catch (e) {
        print("Error parsing Sepah balance: $e");
      }
    }

    // Extract datetime (Format: YY/MM/DD_HH:MM, e.g., "04/02/14_19:30")
    RegExp dateRegex = RegExp(r"(\d{2}/\d{2}/\d{2})_(\d{2}:\d{2})");
    RegExpMatch? dateMatch = dateRegex.firstMatch(text);
    if (dateMatch != null) {
      String dateStr = dateMatch.group(1)!;
      String timeStr = dateMatch.group(2)!;
      List<int> dateParts = dateStr.split('/').map(int.parse).toList();
      List<int> timeParts = timeStr.split(':').map(int.parse).toList();
      int yy = dateParts[0];
      int year = 1400 + yy; // Assuming 14xx for Jalali calendar
      int month = dateParts[1];
      int day = dateParts[2];
      int hour = timeParts[0];
      int minute = timeParts[1];

      try {
        Jalali jdt = Jalali(year, month, day, hour, minute);
        datetime = jdt.toDateTime().toIso8601String();
      } catch (e) {
        print("Error parsing Sepah datetime: $e");
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (datetime not found).",
      );
    }

    // Determine transaction type and expense/income
    if (text.contains("برداشت")) {
      transactionType = "برداشت";
      expenseOrIncome = "expense";
    } else if (text.contains("واریز")) {
      transactionType = "واریز";
      expenseOrIncome = "income";
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (transaction type not determined).",
      );
    }

    // Extract merchant name if present (e.g., "تهرانپارس" on the first line)
    // Needs to handle multiple lines in Dart.
    // The Python regex `^\s*(.+?)\n` means 'start of string, optional whitespace, any chars (non-greedy) until newline'.
    // In Dart, we can process lines. The Python logic checks the *first* line that isn't "*بانك سپه*" or "کارت".
    List<String> lines = text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (lines.isNotEmpty) {
      String firstNonBankOrCardLine = lines.firstWhere(
              (line) => line != "*بانك سپه*" && line != "کارت",
          orElse: () => "" // Return empty string if no such line is found
      );

      if (firstNonBankOrCardLine.isNotEmpty) {
        // Further refine to exclude lines that are clearly not merchant names (e.g., just numbers)
        // This heuristic can be improved based on more samples.
        if (!RegExp(r'^[\d,]+$').hasMatch(firstNonBankOrCardLine) &&
            !firstNonBankOrCardLine.contains("ریال") &&
            !firstNonBankOrCardLine.contains("مبلغ") &&
            !firstNonBankOrCardLine.contains("حساب")) {
          merchantName = firstNonBankOrCardLine;
        }
      }
    }

    // Validate that essential fields are present
    if (amountOfTransaction != null && accountNumber != null && transactionType != null) {
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

    // Fallback error if essential fields are missing despite initial checks
    return BankSmsModel(
      bankName: bankName,
      error: "The given SMS is not a valid transaction SMS (missing essential fields).",
    );
  }
}