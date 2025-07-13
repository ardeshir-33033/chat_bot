import 'package:shamsi_date/shamsi_date.dart';

import 'bank_sms_model.dart'; // For Jalali date handling

// Assuming BankSmsModel is defined in a separate, shared file like 'models/bank_sms_model.dart'
// and imported where needed.
// class BankSmsModel { ... } // (Content provided in a previous turn)

class ShahrSmsParser {
  /// Parse an SMS transaction from Shahr Bank into a BankSmsModel.
  ///
  /// Includes error handling to detect if the SMS is not a valid transaction message.
  /// This function expects numerical digits in Western (0-9) format for regex matching.
  ///
  /// Args:
  ///     text (String): The SMS text to parse.
  ///
  /// Returns:
  ///     BankSmsModel: Parsed transaction details if valid, otherwise a model with an error.
  static BankSmsModel parseShahrSms(String text) {
    String? bankName = "بانک شهر";
    String? accountNumber;
    String? cardNumber; // Not extracted in this parser
    String? transactionType;
    String? expenseOrIncome;
    int? amountOfTransaction;
    int? balance;
    String? datetime;
    String? merchantName; // Not extracted in this parser by the original Python code
    String? error;

    // Check for valid transaction SMS (must contain specific transaction types and no password)
    if ((!text.contains("انتقال وجه کارتي") && !text.contains("خريد با کارت")) ||
        text.contains("رمز:")) {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS.",
      );
    }

    // Extract account number after "واريز به:" (deposit to) or "برداشت از:" (withdrawal from)
    RegExp accountRegex = RegExp(r"(?:واريز به:|برداشت از:)\s*(\d+)");
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
        print("Error parsing Shahr amount: $e");
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
        print("Error parsing Shahr balance: $e");
      }
    }

    // Extract datetime (Format: YYYY/MM/DD HH:MM:SS)
    RegExp dateRegex = RegExp(r"(\d{4})/(\d{2})/(\d{2})\s+(\d{2}):(\d{2}):(\d{2})");
    RegExpMatch? dateMatch = dateRegex.firstMatch(text);
    if (dateMatch != null) {
      try {
        int year = int.parse(dateMatch.group(1)!);
        int month = int.parse(dateMatch.group(2)!);
        int day = int.parse(dateMatch.group(3)!);
        int hour = int.parse(dateMatch.group(4)!);
        int minute = int.parse(dateMatch.group(5)!);
        int second = int.parse(dateMatch.group(6)!);

        // Assuming extracted date components are Jalali, convert to Gregorian ISO 8601
        Jalali jdt = Jalali(year, month, day, hour, minute, second);
        datetime = jdt.toDateTime().toIso8601String();
      } catch (e) {
        print("Error parsing Shahr datetime: $e");
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (datetime not found).",
      );
    }

    // Determine transaction type and expense_or_income
    if (text.contains("انتقال وجه کارتي")) {
      transactionType = "انتقال وجه کارتي";
      expenseOrIncome = "income";
    } else if (text.contains("خريد با کارت")) {
      transactionType = "خريد با کارت";
      expenseOrIncome = "expense";
    } else {
      // This should ideally not be reached if the initial check for transaction types worked.
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (transaction type not determined).",
      );
    }

    // Validate that essential fields are present
    if (accountNumber != null &&
        amountOfTransaction != null &&
        balance != null &&
        datetime != null &&
        transactionType != null) {
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

    // Fallback error if essential fields are missing despite individual checks
    return BankSmsModel(
      bankName: bankName,
      error: "The given SMS is not a valid transaction SMS (missing essential fields).",
    );
  }
}