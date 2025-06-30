import 'package:shamsi_date/shamsi_date.dart';

import 'bank_sms_model.dart';

class AyandehSmsParser {
  static String? _formatAyandehJalaliDateTime(String mmdd, String hh, String mm) {
    try {
      int month = int.parse(mmdd.substring(0, 2));
      int day = int.parse(mmdd.substring(2, 4));
      int hour = int.parse(hh);
      int minute = int.parse(mm);

      // Get current Jalali year using shamsi_date package
      Jalali now = Jalali.now();
      int currentJalaliYear = now.year;

      // Construct Jalali date
      Jalali transactionJalaliDate = Jalali(
        currentJalaliYear,
        month,
        day,
        hour,
        minute,
        0, // seconds
      );

      // Convert to Gregorian and then to ISO 8601 string
      return transactionJalaliDate.toDateTime().toIso8601String();
    } catch (e) {
      // Return null or handle error if date/time parsing fails
      print("Error parsing Ayandeh date/time: $e");
      return null;
    }
  }

  static BankSmsModel parseAyandehSms(String text) {
    // No persianToArabicDigits conversion as per instruction

    // Split and clean lines
    List<String> lines = text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    // Define valid transaction types based on the Python code
    List<String> transactionTypes = [
      "انتقال به كارت",
      "خريد از پايانه فروش",
      "خريداينترنتي",
      "انتقالي",
      "واريز به حساب آينده ساز",
      "برداشت از آينده ساز",
      "حواله پل",
      "انتقالي آبانک",
      "واريز-حواله پايا",
    ];

    // Check for password SMS (contains "رمز")
    if (text.contains("رمز")) {
      return BankSmsModel(
        error:
            "The given SMS is a password/authorization SMS, not a valid transaction SMS.",
      );
    }

    String? transactionType;
    String? expenseOrIncome;
    int? amountOfTransaction;
    int? balance;
    String? datetime;
    String? cardNumber;
    String? accountNumber;
    String? merchantName; // Not explicitly extracted in Python code for Ayandeh

    // Set transaction type
    if (lines.length >= 2) {
      String secondLine = lines[1].trim();
      if (transactionTypes.contains(secondLine)) {
        transactionType = secondLine;
      } else if (secondLine == "خرید") {
        // As per Python logic, return error for simple "خرید"
        return BankSmsModel(
          error: "The given SMS is not a valid transaction SMS.",
        );
      }
    }

    // Extract card number
    RegExp cardRegex = RegExp(r'کارت(\d+)');
    RegExpMatch? mCard = cardRegex.firstMatch(text);
    if (mCard != null) {
      cardNumber = mCard.group(1);
    }

    // Extract account number
    RegExp accountRegex = RegExp(r'حساب(\d+)');
    RegExpMatch? mAccount = accountRegex.firstMatch(text);
    if (mAccount != null) {
      accountNumber = mAccount.group(1);
    }

    // Extract amount and determine expense or income
    for (String ln in lines) {
      // Regex for amount with optional leading/trailing +/- signs
      // Python's regex uses named groups, Dart uses positional groups
      // (?<pref>[-+])? -> group(1) for prefix
      // (?<amt>[\d,]+) -> group(2) for amount
      // (?<post>[-+])? -> group(3) for postfix
      RegExp amountRegex = RegExp(r'^(-|\+)?\s*([\d,]+)\s*(-|\+)?$');
      RegExpMatch? m = amountRegex.firstMatch(ln);
      if (m != null && m.group(2) != null) {
        // Check if amount group exists
        amountOfTransaction = int.parse(m.group(2)!.replaceAll(',', ''));
        String? sign =
            m.group(1) ?? m.group(3); // Check both prefix and postfix for sign
        expenseOrIncome = (sign == '-') ? "expense" : "income";
        break;
      }
    }

    // Extract balance
    RegExp balanceRegex = RegExp(r'مانده[:：]?\s*([\d,]+)');
    RegExpMatch? mBalance = balanceRegex.firstMatch(text);
    if (mBalance != null) {
      balance = int.parse(mBalance.group(1)!.replaceAll(',', ''));
    }

    // Extract datetime (e.g., "0402-13:29" where "0402" is MMDD and "13:29" is HH:MM)
    // Note: The Python regex `(\d{4})\s*[-]\s*(\d{2}):(\d{2})` and subsequent
    // substring logic implies that the first `\d{4}` is the MMDD part of the date.
    // However, typical SMS like '040206-13:29' would mean YYMMDD.
    // This translation strictly follows the Python regex, which captures only MMDD and ignores YY and the last DD.
    // If the full YYMMDD is intended, the regex would need to be adjusted (e.g., `(\d{6})\s*[-]\s*(\d{2}):(\d{2})`).
    // The current implementation is a direct translation of the provided Python logic.
    RegExp datetimeRegex = RegExp(r'(\d{4})\s*[-]\s*(\d{2}):(\d{2})');
    RegExpMatch? mDatetime = datetimeRegex.firstMatch(text);
    if (mDatetime != null) {
      String mmdd = mDatetime.group(1)!; // MMDD string from the regex
      String hh = mDatetime.group(2)!; // Hour
      String mm = mDatetime.group(3)!; // Minute

      datetime = _formatAyandehJalaliDateTime(mmdd, hh, mm);
    }

    // Validation: Ensure critical fields are present for a valid transaction
    List<String> requiredFields = [
      "amount_of_transaction",
      "balance",
      "datetime",
      "transaction_type",
    ];
    // Check if all required fields are NOT null
    bool allFieldsPresent = requiredFields.every((field) {
      // Use toJson() to get a map and then check values from there
      final currentResultMap = <String, dynamic>{
        "amount_of_transaction": amountOfTransaction,
        "balance": balance,
        "datetime": datetime,
        "transaction_type": transactionType,
        // Add other fields if needed for comprehensive validation
      };
      return currentResultMap[field] != null;
    });

    if (!allFieldsPresent) {
      return BankSmsModel(
        error: "The given SMS is not a valid transaction SMS.",
      );
    }

    return BankSmsModel(
      bankName: "بانک آینده",
      accountNumber: accountNumber,
      cardNumber: cardNumber,
      transactionType: transactionType,
      expenseOrIncome: expenseOrIncome,
      amountOfTransaction: amountOfTransaction,
      balance: balance,
      datetime: datetime,
      merchantName: merchantName,
    );
  }
}
