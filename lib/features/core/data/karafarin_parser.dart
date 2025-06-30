import 'package:shamsi_date/shamsi_date.dart';

import 'bank_sms_model.dart'; // Ensure this package is in your pubspec.yaml

// Assuming BankSmsModel is defined in a separate, shared file like 'models/bank_sms_model.dart'
// and imported where needed.
// class BankSmsModel { ... } // (Content provided in a previous turn)

class KarafarinSmsParser {
  // Helper function to convert Persian digits to English (Arabic) digits,
  // now a static method of the class.
  // This is included as per the user's provided Python code, despite previous instructions.
  static String convertPersianToEnglishNumbers(String input) {
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    var output = input;
    for (int i = 0; i < persian.length; i++) {
      output = output.replaceAll(persian[i], english[i]);
    }
    return output;
  }

  /// Parses an SMS text from Karafarin Bank and returns a BankSmsModel.
  ///
  /// This function converts Persian digits to English digits internally
  /// before applying regex patterns, as per the provided code.
  static BankSmsModel parseKarafarinSms(String text) {
    final lines = text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    // Check for non-transaction SMS like password/authorization
    if (text.contains('رمز:') &&
        (text.contains('انتقال به') || text.contains('رمز یک بار مصرف'))) {
      return BankSmsModel(
        error: 'The given SMS is not a valid transaction SMS.',
      );
    }

    String? accountNumber;
    String? transactionType;
    String? expenseOrIncome;
    int? amount;
    int? balance;
    String? dateTimeString;

    for (final line in lines) {
      // Convert Persian numbers to English (Arabic) before regex matching
      final cleanedLine = convertPersianToEnglishNumbers(line);

      // Extract amount and account number for "واريز به"
      RegExp depositRegex = RegExp(r'واريز به: (\d+)\s*مبلغ: ([\d,]+) ريال');
      Match? depositMatch = depositRegex.firstMatch(cleanedLine);
      if (depositMatch != null) {
        accountNumber = depositMatch.group(1);
        amount = int.parse(depositMatch.group(2)!.replaceAll(',', ''));
        transactionType = 'واریز';
        expenseOrIncome = 'income';
        continue;
      }

      // Extract amount and account number for "برداشت از"
      RegExp withdrawalRegex = RegExp(
        r'برداشت از: (\d+)\s*مبلغ: ([\d,]+) ريال',
      );
      Match? withdrawalMatch = withdrawalRegex.firstMatch(cleanedLine);
      if (withdrawalMatch != null) {
        accountNumber = withdrawalMatch.group(1);
        amount = int.parse(withdrawalMatch.group(2)!.replaceAll(',', ''));
        transactionType = 'برداشت';
        expenseOrIncome = 'expense';
        continue;
      }

      // Extract balance
      RegExp balanceRegex = RegExp(r'موجودي: ([\d,]+) ريال');
      Match? balanceMatch = balanceRegex.firstMatch(cleanedLine);
      if (balanceMatch != null) {
        balance = int.parse(balanceMatch.group(1)!.replaceAll(',', ''));
        continue;
      }

      // Extract date and time
      RegExp dateTimeRegex = RegExp(
        r'(\d{2})\/(\d{2})\/(\d{2})_(\d{2}):(\d{2})',
      );
      Match? dateTimeMatch = dateTimeRegex.firstMatch(cleanedLine);
      if (dateTimeMatch != null) {
        final yearShort = int.parse(dateTimeMatch.group(1)!);
        final month = int.parse(dateTimeMatch.group(2)!);
        final day = int.parse(dateTimeMatch.group(3)!);
        final hour = int.parse(dateTimeMatch.group(4)!);
        final minute = int.parse(dateTimeMatch.group(5)!);

        // Assume the year is 14YY, where YY is the two-digit year from the SMS
        final fullYear = 1400 + yearShort;

        final jDate = Jalali(fullYear, month, day);
        // Convert Jalali date to Gregorian and then format to ISO 8601 string.
        // Assuming ISO 8601 for Gregorian is the standard for 'datetime' output.
        final gDate = jDate.toGregorian();
        dateTimeString =
        '${gDate.year.toString().padLeft(4, '0')}-'
            '${gDate.month.toString().padLeft(2, '0')}-'
            '${gDate.day.toString().padLeft(2, '0')}T'
            '${hour.toString().padLeft(2, '0')}:'
            '${minute.toString().padLeft(2, '0')}:00';
        continue;
      }
    }

    // Final validation to ensure essential fields are captured for a valid transaction
    if (amount == null ||
        balance == null ||
        dateTimeString == null ||
        transactionType == null) {
      return BankSmsModel(
        error: 'The given SMS is not a valid transaction SMS.',
      );
    }

    return BankSmsModel(
      bankName: "بانک کارآفرین",
      accountNumber: accountNumber,
      transactionType: transactionType,
      expenseOrIncome: expenseOrIncome,
      amountOfTransaction: amount,
      balance: balance,
      datetime: dateTimeString,
      merchantName:
      null, // Merchant name is not explicitly available in provided Karafarin SMS
    );
  }
}