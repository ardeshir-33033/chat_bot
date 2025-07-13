import 'package:shamsi_date/shamsi_date.dart';

import 'ayandeh_parser.dart';
import 'bank_sms_model.dart';
import 'maskan_parser.dart'; // For Jalali date handling

// Assuming BankSmsModel is defined in a separate, shared file like 'models/bank_sms_model.dart'
// and imported where needed.
// class BankSmsModel { ... } // (Content provided in a previous turn)

class WepodSmsParser {
  /// Parse an SMS transaction from Wepod Bank into a BankSmsModel.
  ///
  /// This function expects numerical digits in Western (0-9) format for regex matching.
  /// It removes common invisible control characters from the input text.
  /// The year for the transaction datetime is hardcoded to 1402 (Jalali).
  ///
  /// Args:
  ///     text (String): The SMS text to parse.
  ///
  /// Returns:
  ///     BankSmsModel: Parsed transaction details if valid, otherwise a model with an error.
  static BankSmsModel parseWepodSms(String text) {
    String? bankName = "ویپاد";
    String? accountNumber;
    String? cardNumber; // Not extracted in this parser
    String? transactionType;
    String? expenseOrIncome;
    int? amountOfTransaction;
    int? balance;
    String? datetime;
    String? merchantName; // Not extracted in this parser
    String? error;

    // Remove invisible control characters
    text = text.replaceAll(RegExp(r'[\u200B-\u200F\uFEFF]'), '');

    // Split and clean lines
    List<String> lines = text.split('\n').map((ln) => ln.trim()).where((ln) => ln.isNotEmpty).toList();

    // Check if there are exactly four lines as per Python logic
    if (lines.length != 4) {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (expected 4 lines).",
      );
    }

    // Check if the first line consists only of digits and dots (assumed account number)
    if (!RegExp(r"^[\d.]+$").hasMatch(lines[0])) {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (invalid account number format).",
      );
    }
    accountNumber = lines[0];

    // Parse the second line: amount with sign
    RegExp amountRegex = RegExp(r"([+-])(\d{1,3}(,\d{3})*)");
    RegExpMatch? amountMatch = amountRegex.firstMatch(lines[1]);
    if (amountMatch != null) {
      String sign = amountMatch.group(1)!;
      String amountStr = amountMatch.group(2)!.replaceAll(',', '');
      try {
        amountOfTransaction = int.parse(amountStr);
      } catch (e) {
        print("Error parsing Wepod amount: $e");
        return BankSmsModel(
          bankName: bankName,
          error: "The given SMS is not a valid transaction SMS (amount parsing error).",
        );
      }

      // Determine transaction_type and expense_or_income based on sign
      if (sign == '-') {
        transactionType = "برداشت"; // Withdrawal
        expenseOrIncome = "expense";
      } else if (sign == '+') {
        transactionType = "واریز"; // Deposit
        expenseOrIncome = "income";
      } else {
        // This case should ideally not be reached if regex correctly captures '+' or '-'
        return BankSmsModel(
          bankName: bankName,
          error: "The given SMS is not a valid transaction SMS (invalid sign in amount).",
        );
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (amount not found).",
      );
    }

    // Parse the third line: date and time (MM/DD_HH:MM)
    RegExp dateTimeRegex = RegExp(r"(\d{2})/(\d{2})_(\d{2}):(\d{2})");
    RegExpMatch? dateTimeMatch = dateTimeRegex.firstMatch(lines[2]);
    if (dateTimeMatch != null) {
      try {
        int month = int.parse(dateTimeMatch.group(1)!);
        int day = int.parse(dateTimeMatch.group(2)!);
        int hour = int.parse(dateTimeMatch.group(3)!);
        int minute = int.parse(dateTimeMatch.group(4)!);

        // Hardcode year to 1402 (Jalali year assumed from original Python logic)
        int jalaliYear = 1402;
        // Form datetime using Jalali and convert to Gregorian ISO 8601
        Jalali jdt = Jalali(jalaliYear, month, day, hour, minute, 0); // Seconds are 0
        datetime = jdt.toDateTime().toIso8601String();
      } catch (e) {
        print("Error parsing Wepod datetime components: $e");
        return BankSmsModel(
          bankName: bankName,
          error: "The given SMS is not a valid transaction SMS (datetime parsing error).",
        );
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (datetime not found).",
      );
    }

    // Parse the fourth line: balance
    RegExp balanceRegex = RegExp(r"مانده: ([\d,]+)");
    RegExpMatch? balanceMatch = balanceRegex.firstMatch(lines[3]);
    if (balanceMatch != null) {
      String balanceStr = balanceMatch.group(1)!.replaceAll(',', '');
      try {
        balance = int.parse(balanceStr);
      } catch (e) {
        print("Error parsing Wepod balance: $e");
        return BankSmsModel(
          bankName: bankName,
          error: "The given SMS is not a valid transaction SMS (balance parsing error).",
        );
      }
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (balance not found).",
      );
    }

    // If all essential fields are parsed, return the model.
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

    // Fallback error if any critical field is still null (should be caught by specific checks above)
    return BankSmsModel(
      bankName: bankName,
      error: "The given SMS is not a valid transaction SMS (missing essential parsed fields).",
    );
  }
}
