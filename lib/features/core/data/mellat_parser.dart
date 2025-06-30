import 'package:shamsi_date/shamsi_date.dart';

import 'bank_sms_model.dart'; // For Jalali date handling

// Assuming BankSmsModel is defined in a separate, shared file like 'models/bank_sms_model.dart'
// and imported where needed.
// class BankSmsModel { ... } // (Content provided in a previous turn)

class MellatSmsParser {
  /// Parse an SMS transaction from Mellat Bank into a BankSmsModel.
  ///
  /// Includes error handling to detect if the SMS is not a valid transaction message,
  /// such as OTP or promotional SMSs.
  /// This function expects numerical digits in Western (0-9) format for regex matching.
  ///
  /// Args:
  ///     text (String): The SMS text to parse.
  ///
  /// Returns:
  ///     BankSmsModel: Parsed transaction details if valid, otherwise a model with an error.
  static BankSmsModel parseMellatSms(String text) {
    String? bankName = "بانک ملت";
    String? accountNumber;
    String? cardNumber; // Not extracted in this parser
    String? transactionType;
    String? expenseOrIncome;
    int? amountOfTransaction;
    int? balance;
    String? datetime;
    String? merchantName; // Not extracted in this parser
    String? error;

    // Check for non-transaction SMS (e.g., OTP containing "رمز")
    if (text.contains("رمز")) {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (contains OTP keyword).",
      );
    }

    // Extract account number
    RegExp accountRegex = RegExp(r"(?:حساب|به حساب)\s*(\d+)");
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
    RegExp amountRegex = RegExp(r"مبلغ\s*[:]?\s*([\d,]+)\s*ریال");
    RegExpMatch? amountMatch = amountRegex.firstMatch(text);
    if (amountMatch != null) {
      String amountStr = amountMatch.group(1)!.replaceAll(',', '');
      try {
        amountOfTransaction = int.parse(amountStr);
      } catch (e) {
        print("Error parsing Mellat amount: $e");
      }
    } else {
      // Alternative pattern for concise format, e.g., "برداشت120,000"
      RegExp altAmountRegex = RegExp(r"(?:برداشت|واریز)([\d,]+)");
      RegExpMatch? altAmountMatch = altAmountRegex.firstMatch(text);
      if (altAmountMatch != null) {
        String amountStr = altAmountMatch.group(1)!.replaceAll(',', '');
        try {
          amountOfTransaction = int.parse(amountStr);
        } catch (e) {
          print("Error parsing Mellat alternative amount: $e");
        }
      } else {
        return BankSmsModel(
          bankName: bankName,
          error: "The given SMS is not a valid transaction SMS (amount not found).",
        );
      }
    }

    // Extract balance
    RegExp balanceRegex = RegExp(r"(?:مانده|موجودی)\s*[:]?\s*([\d,]+)\s*ریال");
    RegExpMatch? balanceMatch = balanceRegex.firstMatch(text);
    if (balanceMatch != null) {
      String balanceStr = balanceMatch.group(1)!.replaceAll(',', '');
      try {
        balance = int.parse(balanceStr);
      } catch (e) {
        print("Error parsing Mellat balance: $e");
      }
    } else {
      // Alternative pattern for concise format, e.g., "مانده3,346,929"
      RegExp altBalanceRegex = RegExp(r"مانده([\d,]+)");
      RegExpMatch? altBalanceMatch = altBalanceRegex.firstMatch(text);
      if (altBalanceMatch != null) {
        String balanceStr = altBalanceMatch.group(1)!.replaceAll(',', '');
        try {
          balance = int.parse(balanceStr);
        } catch (e) {
          print("Error parsing Mellat alternative balance: $e");
        }
      }
    }

    // Extract datetime
    // Format 1: YYYY/MM/DD HH:MM, e.g., "1402/11/16 10:11"
    RegExp dateRegex1 = RegExp(r"(\d{4}/\d{2}/\d{2})\s+(\d{2}:\d{2})");
    RegExpMatch? dateMatch1 = dateRegex1.firstMatch(text);
    if (dateMatch1 != null) {
      String dateStr = dateMatch1.group(1)!;
      String timeStr = dateMatch1.group(2)!;
      List<int> dateParts = dateStr.split('/').map(int.parse).toList();
      List<int> timeParts = timeStr.split(':').map(int.parse).toList();
      try {
        Jalali jdt = Jalali(dateParts[0], dateParts[1], dateParts[2], timeParts[0], timeParts[1]);
        datetime = jdt.toDateTime().toIso8601String();
      } catch (e) {
        print("Error parsing Mellat datetime format 1: $e");
      }
    } else {
      // Format 2: YY/MM/DD-HH:MM, e.g., "04/01/22-08:53"
      RegExp dateRegex2 = RegExp(r"(\d{2}/\d{2}/\d{2})-(\d{2}:\d{2})");
      RegExpMatch? dateMatch2 = dateRegex2.firstMatch(text);
      if (dateMatch2 != null) {
        String dateStr = dateMatch2.group(1)!;
        String timeStr = dateMatch2.group(2)!;
        List<int> dateParts = dateStr.split('/').map(int.parse).toList();
        List<int> timeParts = timeStr.split(':').map(int.parse).toList();
        int yy = dateParts[0];
        int year = 1400 + yy; // Assume 14xx for Jalali calendar
        try {
          Jalali jdt = Jalali(year, dateParts[1], dateParts[2], timeParts[0], timeParts[1]);
          datetime = jdt.toDateTime().toIso8601String();
        } catch (e) {
          print("Error parsing Mellat datetime format 2: $e");
        }
      } else {
        // Format 3: YYYY/MM/DD, e.g., "1404/01/31"
        RegExp dateRegex3 = RegExp(r"(\d{4}/\d{2}/\d{2})");
        RegExpMatch? dateMatch3 = dateRegex3.firstMatch(text);
        if (dateMatch3 != null) {
          String dateStr = dateMatch3.group(1)!;
          List<int> dateParts = dateStr.split('/').map(int.parse).toList();
          try {
            Jalali jdt = Jalali(dateParts[0], dateParts[1], dateParts[2]);
            datetime = jdt.toDateTime().toIso8601String();
          } catch (e) {
            print("Error parsing Mellat datetime format 3: $e");
          }
        } else {
          return BankSmsModel(
            bankName: bankName,
            error: "The given SMS is not a valid transaction SMS (datetime not found).",
          );
        }
      }
    }

    // Determine transaction type
    if (text.contains("واریز") || text.contains("افزایش") || text.contains("کد شبا") || text.contains("پرداخت به")) {
      transactionType = "واریز";
      expenseOrIncome = "income";
    } else if (text.contains("برداشت") || text.contains("خرید") || text.contains("پرداخت قبض") || text.contains("کسر")) {
      transactionType = "برداشت"; // A generic term for expense
      expenseOrIncome = "expense";
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (transaction type not determined).",
      );
    }

    // If transaction is valid (at least amount, account number, and transaction type)
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

    return BankSmsModel(
      bankName: bankName,
      error: "The given SMS is not a valid transaction SMS (missing essential fields).",
    );
  }
}