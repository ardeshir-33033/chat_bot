import 'package:shamsi_date/shamsi_date.dart';

import 'bank_sms_model.dart'; // For Jalali date handling

// Assuming BankSmsModel is defined in a separate, shared file like 'models/bank_sms_model.dart'
// and imported where needed.
// class BankSmsModel { ... } // (Content provided in a previous turn)

class BlueSmsParser {
  /// Helper function to convert Persian digits to Arabic (Western) digits,
  /// now a static method of the class.
  static String persianToArabicDigits(String text) {
    const String persianDigits = "۰۱۲۳۴۵۶۷۸۹";
    const String arabicDigits = "0123456789";
    String result = text;
    for (int i = 0; i < persianDigits.length; i++) {
      result = result.replaceAll(persianDigits[i], arabicDigits[i]);
    }
    return result;
  }

  static BankSmsModel parseBlueSms(String text) {
    String? bankName = "بلو";
    String? accountNumber; // Not explicitly extracted in Blue parser
    String? cardNumber; // Not explicitly extracted in Blue parser
    String? transactionType;
    String? expenseOrIncome;
    int? amountOfTransaction;
    int? balance;
    String? datetime;
    String? merchantName; // Not explicitly extracted in Blue parser
    String? error;

    // Convert Persian digits to Arabic digits and clean lines
    List<String> lines = text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .map((line) => persianToArabicDigits(line)) // Apply conversion here
        .toList();

    // Initial checks for valid Blue Bank SMS
    if (lines.isEmpty || lines[0] != "بلو") {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS.",
      );
    }

    if (lines.length < 2) {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (too short).",
      );
    }

    transactionType = lines[1];
    // Non-transaction SMS types
    if (transactionType == "بفرمایید رمز پویا" || transactionType == "بفرمایید وام 💸") {
      return BankSmsModel(
        bankName: bankName,
        error: "The given SMS is not a valid transaction SMS (non-transactional type).",
      );
    }

    // Define transaction types
    List<String> expenseTypes = ["برداشت پول", "انتقال پل", "این باکس", "پرداخت قبض", "رندباکس"];
    List<String> incomeTypes = ["واریز پول", "دریافت پل", "برگشت پول", "سود شما", "آن باکس"];

    // Classify transaction
    if (expenseTypes.contains(transactionType)) {
      expenseOrIncome = "expense";
    } else if (incomeTypes.contains(transactionType)) {
      expenseOrIncome = "income";
    } else {
      return BankSmsModel(
        bankName: bankName,
        error: "Unknown transaction type.",
      );
    }

    // Extract amount from description line (typically line 2)
    if (lines.length > 2) {
      String descriptionLine = lines[2];
      RegExp amountRegex = RegExp(r"([\d,]+) ریال");
      RegExpMatch? match = amountRegex.firstMatch(descriptionLine);
      if (match != null) {
        String amountStr = match.group(1)!.replaceAll(',', '');
        try {
          amountOfTransaction = int.parse(amountStr);
        } catch (e) {
          print("Error parsing Blue amount: $e");
        }
      }
    }

    // Extract balance from any line containing "موجودی" or "موجودی حساب"
    String? balanceLine;
    RegExp balancePattern = RegExp(r"موجودی( حساب)?: ([\d,]+) ریال");
    for (String ln in lines) {
      if (balancePattern.hasMatch(ln)) {
        balanceLine = ln;
        break; // Found it, no need to search further
      }
    }

    if (balanceLine != null) {
      RegExpMatch? match = balancePattern.firstMatch(balanceLine);
      if (match != null) {
        String balanceStr = match.group(2)!.replaceAll(',', '');
        try {
          balance = int.parse(balanceStr);
        } catch (e) {
          print("Error parsing Blue balance: $e");
        }
      }
    }

    // Initialize date and time components
    int? hour;
    int? minute;
    int? year;
    int? month;
    int? day;

    // Extract time (HH:MM or H:MM)
    String? timeLine;
    RegExp timePattern = RegExp(r"^\d{1,2}:\d{2}$");
    for (String ln in lines) {
      if (timePattern.hasMatch(ln)) {
        timeLine = ln;
        break;
      }
    }

    if (timeLine != null) {
      RegExp timeRegex = RegExp(r"(\d{1,2}):(\d{2})");
      RegExpMatch? match = timeRegex.firstMatch(timeLine);
      if (match != null) {
        hour = int.parse(match.group(1)!);
        minute = int.parse(match.group(2)!);
      }
    }

    // Extract date (YYYY.MM.DD)
    String? dateLine;
    RegExp datePattern = RegExp(r"^\d{4}\.\d{2}\.\d{2}$");
    for (String ln in lines) {
      if (datePattern.hasMatch(ln)) {
        dateLine = ln;
        break;
      }
    }

    if (dateLine != null) {
      RegExp dateRegex = RegExp(r"(\d{4})\.(\d{2})\.(\d{2})");
      RegExpMatch? match = dateRegex.firstMatch(dateLine);
      if (match != null) {
        year = int.parse(match.group(1)!);
        month = int.parse(match.group(2)!);
        day = int.parse(match.group(3)!);
      }
    }

    // Combine time and date into datetime if all components are present
    if (hour != null && minute != null && year != null && month != null && day != null) {
      try {
        Jalali jdt = Jalali(year, month, day, hour, minute);
        datetime = jdt.toDateTime().toIso8601String();
      } catch (e) {
        print("Error combining Blue date and time: $e");
      }
    }

    // Validate required fields and return result
    // These are the critical fields for a transaction SMS
    bool isValidTransaction = (amountOfTransaction != null && balance != null && datetime != null);

    if (!isValidTransaction) {
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