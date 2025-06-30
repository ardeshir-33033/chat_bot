import 'package:shamsi_date/shamsi_date.dart';

import 'bank_sms_model.dart'; // Ensure this package is in your pubspec.yaml

// Assuming BankSmsModel is defined in a separate, shared file like 'models/bank_sms_model.dart'
// and imported where needed.
// class BankSmsModel { ... } // (Content provided in a previous turn)

class PasargadSmsParser {
  /// Parses an SMS text from Pasargad Bank and returns a BankSmsModel.
  ///
  /// This function expects numerical digits in Western (0-9) format for regex matching.
  static BankSmsModel parsePasargadSms(String text) {
    String? bankName = "بانک پاسارگاد";
    String? accountNumber;
    String? cardNumber; // Not explicitly extracted in Pasargad parser
    String? transactionType;
    String? expenseOrIncome;
    int? amountOfTransaction;
    int? balance;
    String? datetime;
    String? merchantName; // Not explicitly extracted in Pasargad parser
    String? error;

    // Split and clean lines
    List<String> lines = text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    // Check for non-transaction SMS (e.g., password error, mobile banking login)
    if (lines.any((line) => line.contains("رمز") && line.contains("اشتباه وارد شده است")) ||
        lines.any((line) => line.contains("ورود به موبایل بانک"))) {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS.",
      );
    }

    // --- Try parsing standard transaction format ---
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      // Account number (e.g., 262.8000.14036920.1)
      RegExp accountNumRegex = RegExp(r"^\d{3}\.\d{4}\.\d{8}\.\d$");
      if (accountNumRegex.hasMatch(line)) {
        accountNumber = line;

        // Expect amount, datetime, and balance in subsequent lines
        if (i + 3 < lines.length) {
          // Amount (e.g., -7,334,000 or +3,000,000)
          String amountLine = lines[i + 1];
          RegExp amountRegex = RegExp(r"([+-])([\d,]+)");
          RegExpMatch? matchAmount = amountRegex.firstMatch(amountLine);
          if (matchAmount != null) {
            String sign = matchAmount.group(1)!;
            String amountStr = matchAmount.group(2)!.replaceAll(',', '');
            try {
              amountOfTransaction = int.parse(amountStr);
            } catch (e) {
              print("Error parsing Pasargad amount (standard): $e");
            }
            expenseOrIncome = (sign == "+") ? "income" : "expense";
            transactionType = "تراکنش کارت"; // Default for standard transactions
          }

          // Datetime (e.g., 02/10_08:42 as MM/DD_HH:MM)
          String datetimeLine = lines[i + 2];
          RegExp datetimeRegex = RegExp(r"(\d{2})/(\d{2})_(\d{2}):(\d{2})");
          RegExpMatch? matchDatetime = datetimeRegex.firstMatch(datetimeLine);
          if (matchDatetime != null) {
            try {
              int month = int.parse(matchDatetime.group(1)!);
              int day = int.parse(matchDatetime.group(2)!);
              int hour = int.parse(matchDatetime.group(3)!);
              int minute = int.parse(matchDatetime.group(4)!);

              Jalali now = Jalali.now();
              int jy = now.year; // Assume current Jalali year

              Jalali transactionJalaliDate = Jalali(jy, month, day, hour, minute, 0);
              datetime = transactionJalaliDate.toDateTime().toIso8601String();
            } catch (e) {
              print("Error parsing Pasargad datetime (standard): $e");
            }
          }

          // Balance (e.g., مانده: 5,739,435)
          String balanceLine = lines[i + 3];
          RegExp balanceRegex = RegExp(r"مانده:([\d,]+)");
          RegExpMatch? matchBalance = balanceRegex.firstMatch(balanceLine);
          if (matchBalance != null) {
            String balanceStr = matchBalance.group(1)!.replaceAll(',', '');
            try {
              balance = int.parse(balanceStr);
            } catch (e) {
              print("Error parsing Pasargad balance (standard): $e");
            }
          }
        }
        break; // Found the account number, processed the block, exit loop
      }
    }

    // If standard transaction is valid (at least amount and account number)
    if (amountOfTransaction != null && accountNumber != null) {
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

    // --- Try parsing cashback transaction format ---
    bool isCashback = lines.any((line) => line.contains("سند برگشت عملیات"));
    if (isCashback) {
      transactionType = "برگشت وجه"; // Set default transaction type for cashback
      expenseOrIncome = "income"; // Set default income for cashback

      for (String line in lines) {
        // Account number (e.g., واريز به: 262.8000.14036920.1)
        RegExp cashbackAccountRegex = RegExp(r"واريز به: (\d{3}\.\d{4}\.\d{8}\.\d)");
        RegExpMatch? matchAccount = cashbackAccountRegex.firstMatch(line);
        if (matchAccount != null) {
          accountNumber = matchAccount.group(1);
        }

        // Amount (e.g., مبلغ: 91,000 ريال)
        RegExp cashbackAmountRegex = RegExp(r"مبلغ: ([\d,]+) ريال");
        RegExpMatch? matchAmount = cashbackAmountRegex.firstMatch(line);
        if (matchAmount != null) {
          String amountStr = matchAmount.group(1)!.replaceAll(',', '');
          try {
            amountOfTransaction = int.parse(amountStr);
          } catch (e) {
            print("Error parsing Pasargad amount (cashback): $e");
          }
        }

        // Datetime (e.g., 03/12/30_18:01 as YY/MM/DD_HH:MM)
        RegExp cashbackDatetimeRegex = RegExp(r"(\d{2})/(\d{2})/(\d{2})_(\d{2}):(\d{2})");
        RegExpMatch? matchDatetime = cashbackDatetimeRegex.firstMatch(line);
        if (matchDatetime != null) {
          try {
            int yearYY = int.parse(matchDatetime.group(1)!);
            int month = int.parse(matchDatetime.group(2)!);
            int day = int.parse(matchDatetime.group(3)!);
            int hour = int.parse(matchDatetime.group(4)!);
            int minute = int.parse(matchDatetime.group(5)!);

            // Convert YY to full year (assume 14xx in Jalali calendar for recent dates)
            // Given current Jalali year logic, this attempts to place the 2-digit year.
            int fullYear;
            if (yearYY >= 80) {
              fullYear = 1300 + yearYY;
            } else {
              fullYear = 1400 + yearYY;
            }

            Jalali transactionJalaliDate = Jalali(fullYear, month, day, hour, minute, 0);
            datetime = transactionJalaliDate.toDateTime().toIso8601String();
          } catch (e) {
            print("Error parsing Pasargad datetime (cashback): $e");
          }
        }

        // Balance (e.g., موجودي: 212,715 ريال)
        RegExp cashbackBalanceRegex = RegExp(r"موجودي: ([\d,]+) ريال");
        RegExpMatch? matchBalance = cashbackBalanceRegex.firstMatch(line);
        if (matchBalance != null) {
          String balanceStr = matchBalance.group(1)!.replaceAll(',', '');
          try {
            balance = int.parse(balanceStr);
          } catch (e) {
            print("Error parsing Pasargad balance (cashback): $e");
          }
        }
      }

      // If cashback transaction is valid
      if (amountOfTransaction != null && accountNumber != null) {
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

    // If neither format matches, return error
    return BankSmsModel(
      bankName: bankName,
      error: "The given SMS is not a valid transaction SMS.",
    );
  }
}