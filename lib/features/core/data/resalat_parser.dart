import 'package:shamsi_date/shamsi_date.dart';

import 'bank_sms_model.dart'; // For Jalali date handling

// Assuming BankSmsModel is defined in a separate, shared file like 'models/bank_sms_model.dart'
// and imported where needed.
// class BankSmsModel { ... } // (Content provided in a previous turn)

class ResalatSmsParser {
  /// Parse an SMS transaction from Resalat Bank into a BankSmsModel.
  ///
  /// Includes strict error handling to detect if the SMS is not a valid transaction message.
  /// Handles special withdrawal SMS for SMS fees.
  /// This function expects numerical digits in Western (0-9) format for regex matching.
  ///
  /// Args:
  ///     text (String): The SMS text to parse.
  ///
  /// Returns:
  ///     BankSmsModel: Parsed transaction details if valid, otherwise a model with an error.
  static BankSmsModel parseResalatSms(String text) {
    String? bankName = "بانک قرض الحسنه رسالت";
    String? accountNumber;
    String? cardNumber;
    String? transactionType;
    String? expenseOrIncome;
    int? amountOfTransaction;
    int? balance;
    String? datetime;
    String? merchantName;
    String? error; // Local variable to hold error message

    // Split and clean lines
    List<String> lines = text.split('\n').map((ln) => ln.trim()).where((ln) => ln.isNotEmpty).toList();

    // Check for non-transaction SMS patterns
    List<RegExp> nonTransactionPatterns = [
      RegExp(r"کد ورود:"),
      RegExp(r"رمز اول کارت"),
      RegExp(r"اشتباه وارد شده است"),
      RegExp(r"ورود به همراه بانک")
    ];
    if (nonTransactionPatterns.any((pattern) => pattern.hasMatch(text))) {
      return BankSmsModel(bankName: bankName, error: "The given SMS is not a valid transaction SMS.");
    }

    // Special case: Withdrawal for SMS fees
    if (text.contains("مبلغ برداشت شده از حساب شما بابت هزینه پیامکهای شش ماهه اول ۱۴۰۳")) {
      transactionType = "برداشت";
      expenseOrIncome = "expense";
      merchantName = "هزینه پیامکهای شش ماهه اول ۱۴۰۳";
      // Amount and balance are not specified; leave as null
      // Year 1403 is mentioned, but no specific date, default to start of 1403
      try {
        // Convert Jalali 1403/01/01 to Gregorian ISO 8601
        Jalali jdt = Jalali(1403, 1, 1, 0, 0, 0);
        datetime = jdt.toDateTime().toIso8601String();
      } catch (e) {
        print("Error setting default datetime for Resalat SMS fee: $e");
        // Don't fail the whole parse if only default datetime has an issue
      }
      return BankSmsModel(
        bankName: bankName,
        accountNumber: accountNumber, // Will be null here
        cardNumber: cardNumber, // Will be null here
        transactionType: transactionType,
        expenseOrIncome: expenseOrIncome,
        amountOfTransaction: amountOfTransaction, // Will be null here
        balance: balance, // Will be null here
        datetime: datetime,
        merchantName: merchantName,
        error: null,
      );
    }

    List<String> unmatchedLines = [];

    for (String line in lines) {
      // Check for account number (e.g., 12345.678.901)
      if (RegExp(r'^\d+\.\d+\.\d+$').hasMatch(line)) {
        accountNumber = line;
        continue;
      }

      // Check for transaction type (purchase or payment)
      if (line == "خرید" || line == "پرداخت") {
        transactionType = line;
        expenseOrIncome = "expense";
        continue;
      }

      // Check for amount with sign (general transactions, e.g., +50,000 or -50,000)
      RegExp amountSignRegex = RegExp(r'^[+-][\d,]+$');
      RegExpMatch? amountSignMatch = amountSignRegex.firstMatch(line);
      if (amountSignMatch != null) {
        String sign = amountSignMatch.group(0)![0];
        String amountStr = amountSignMatch.group(0)!.substring(1).replaceAll(',', '').trim();
        try {
          amountOfTransaction = int.parse(amountStr);
        } catch (e) {
          print("Error parsing Resalat amount: $e");
          unmatchedLines.add(line); // Treat as unmatched if amount parsing fails
          continue;
        }
        expenseOrIncome = (sign == "+") ? "income" : "expense";
        if (transactionType == null) {
          transactionType = "انتقال";
        }
        continue;
      }

      // Check for balance (e.g., مانده: 1,000,000)
      if (line.contains("مانده:")) {
        List<String> parts = line.split("مانده:");
        if (parts.length > 1) {
          String balanceStr = parts[1].split(' ')[0].replaceAll(',', '');
          try {
            balance = int.parse(balanceStr);
          } catch (e) {
            print("Error parsing Resalat balance: $e");
            unmatchedLines.add(line);
            continue;
          }
        }
        continue;
      }

      // Check for card number (e.g., کارت: 1234)
      if (line.contains("کارت:")) {
        List<String> parts = line.split("کارت:");
        if (parts.length > 1) {
          cardNumber = parts[1].trim();
        }
        continue;
      }

      // Check for merchant name (e.g., از: فروشگاه XYZ)
      if (line.contains("از:") && (transactionType == "خرید" || transactionType == "پرداخت")) {
        List<String> parts = line.split("از:");
        if (parts.length > 1) {
          merchantName = parts[1].trim();
        }
        continue;
      }

      // Check for datetime (general transaction, MM/DD_HH:MM)
      RegExp dateTimeGeneralRegex = RegExp(r'(\d{2})/(\d{2})_(\d{2}):(\d{2})');
      RegExpMatch? dateTimeGeneralMatch = dateTimeGeneralRegex.firstMatch(line);
      if (dateTimeGeneralMatch != null) {
        try {
          int month = int.parse(dateTimeGeneralMatch.group(1)!);
          int day = int.parse(dateTimeGeneralMatch.group(2)!);
          int hour = int.parse(dateTimeGeneralMatch.group(3)!);
          int minute = int.parse(dateTimeGeneralMatch.group(4)!);
          // Hardcoded year 1404 as per original Python logic for this format
          Jalali jdt = Jalali(1404, month, day, hour, minute, 0); // Seconds are 0
          datetime = jdt.toDateTime().toIso8601String();
        } catch (e) {
          print("Error parsing Resalat general datetime: $e");
          unmatchedLines.add(line);
          continue;
        }
        continue;
      }

      // Check for datetime (purchase transaction, YYYY/MM/DD-HH:MM:SS)
      RegExp dateTimePurchaseRegex = RegExp(r'(\d{4})/(\d{2})/(\d{2})-(\d{2}):(\d{2}):(\d{2})');
      RegExpMatch? dateTimePurchaseMatch = dateTimePurchaseRegex.firstMatch(line);
      if (dateTimePurchaseMatch != null) {
        try {
          int year = int.parse(dateTimePurchaseMatch.group(1)!);
          int month = int.parse(dateTimePurchaseMatch.group(2)!);
          int day = int.parse(dateTimePurchaseMatch.group(3)!);
          int hour = int.parse(dateTimePurchaseMatch.group(4)!);
          int minute = int.parse(dateTimePurchaseMatch.group(5)!);
          int second = int.parse(dateTimePurchaseMatch.group(6)!);
          Jalali jdt = Jalali(year, month, day, hour, minute, second);
          datetime = jdt.toDateTime().toIso8601String();
        } catch (e) {
          print("Error parsing Resalat purchase datetime: $e");
          unmatchedLines.add(line);
          continue;
        }
        continue;
      }

      // Collect unmatched lines for potential merchant name
      unmatchedLines.add(line);
    }

    // Infer merchant name for purchase/payment only if explicitly unmatched and valid context
    if ((transactionType == "خرید" || transactionType == "پرداخت") &&
        merchantName == null &&
        unmatchedLines.isNotEmpty) {
      String potentialMerchant = unmatchedLines[0];
      // Only set merchant name if it doesn't look like a number or a password prompt
      if (!RegExp(r'^[\d,]+$').hasMatch(potentialMerchant) &&
          !potentialMerchant.contains("رمز:")) {
        merchantName = potentialMerchant;
      }
    }

    // Strict validity checking for non-special transactions
    List<String?> requiredFields = [accountNumber, amountOfTransaction?.toString(), balance?.toString(), datetime];
    if (transactionType == "خرید" || transactionType == "پرداخت") {
      requiredFields.add(merchantName);
    }

    if (!requiredFields.every((field) => field != null && field.isNotEmpty)) {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (missing essential fields).",
      );
    }

    // Construct and return the BankSmsModel
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