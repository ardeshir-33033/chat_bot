import 'package:shamsi_date/shamsi_date.dart';

import 'bank_sms_model.dart'; // For Jalali date handling

// Assuming BankSmsModel is defined in a separate, shared file like 'models/bank_sms_model.dart'
// and imported where needed.
// class BankSmsModel { ... } // (Content provided in a previous turn)

class TejaratSmsParser {
  /// Parse an SMS transaction from Tejarat Bank into a BankSmsModel.
  ///
  /// Includes error handling to detect if the SMS is not a valid transaction message.
  /// This function expects numerical digits in Western (0-9) format for regex matching.
  /// It focuses on extracting details of the *first* transaction found in the SMS.
  ///
  /// Args:
  ///     text (String): The SMS text to parse.
  ///
  /// Returns:
  ///     BankSmsModel: Parsed transaction details if valid, otherwise a model with an error.
  static BankSmsModel parseTejaratSms(String text) {
    String? bankName = "بانک تجارت";
    String? accountNumber;
    String? cardNumber; // Not extracted in this parser
    String? transactionType;
    String? expenseOrIncome;
    int? amountOfTransaction;
    int? balance;
    String? datetime;
    String? merchantName; // Not extracted in this parser
    String? error;

    // Extract account number
    RegExp accountRegex = RegExp(r"شماره حساب (\d+)");
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
    RegExp balanceRegex = RegExp(r"مانده بستانکار ([\d,]+) ریال");
    RegExpMatch? balanceMatch = balanceRegex.firstMatch(text);
    if (balanceMatch != null) {
      String balanceStr = balanceMatch.group(1)!.replaceAll(',', '');
      try {
        balance = int.parse(balanceStr);
      } catch (e) {
        print("Error parsing Tejarat balance: $e");
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (balance not found).",
      );
    }

    // Extract date
    RegExp datePattern = RegExp(r"تاریخ (\d{4})/(\d{1,2})/(\d{1,2})");
    RegExpMatch? dateMatch = datePattern.firstMatch(text);
    int? year, month, day;
    if (dateMatch != null) {
      try {
        year = int.parse(dateMatch.group(1)!);
        month = int.parse(dateMatch.group(2)!);
        day = int.parse(dateMatch.group(3)!);
      } catch (e) {
        print("Error parsing Tejarat date components: $e");
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (date not found).",
      );
    }

    // Extract first transaction line (time, type, amount)
    RegExp transactionRegex = RegExp(r"ساعت (\d{2}):(\d{2}) (واریز|برداشت) ([\d,]+) ریال");
    RegExpMatch? transactionMatch = transactionRegex.firstMatch(text);
    if (transactionMatch != null) {
      try {
        int hour = int.parse(transactionMatch.group(1)!);
        int minute = int.parse(transactionMatch.group(2)!);
        String transType = transactionMatch.group(3)!;
        String amountStr = transactionMatch.group(4)!.replaceAll(',', '');

        amountOfTransaction = int.parse(amountStr);
        transactionType = transType;
        expenseOrIncome = (transType == "واریز") ? "income" : "expense";

        // Combine date and time to create Jalali date, then convert to Gregorian ISO 8601
        if (year != null && month != null && day != null) {
          Jalali jdt = Jalali(year, month, day, hour, minute, 0);
          datetime = jdt.toDateTime().toIso8601String();
        }
      } catch (e) {
        print("Error parsing Tejarat transaction details: $e");
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (transaction details not found).",
      );
    }

    // Validate that all essential fields are present before returning a successful model
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