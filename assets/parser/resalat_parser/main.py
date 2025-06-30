import re
import sys    # Required to read command-line arguments
import json   # Required to output the result as JSON

def parse_resalat_sms(text):
    """
    Parse an SMS transaction from Rasalat Bank into a dictionary with keys:
    bank_name, account_number, card_number, transaction_type, expense_or_income,
    amount_of_transaction, balance, datetime (ISO Jalali), merchant_name.

    Includes strict error handling to detect if the SMS is not a valid transaction message.
    Handles special withdrawal SMS for SMS fees.

    Args:
        text (str): The SMS text to parse.

    Returns:
        dict: Parsed transaction details if valid, otherwise an error dictionary.
    """
    result = {
        "bank_name": "بانک قرض الحسنه رسالت",
        "account_number": None,
        "card_number": None,
        "transaction_type": None,
        "expense_or_income": None,
        "amount_of_transaction": None,
        "balance": None,
        "datetime": None,
        "merchant_name": None
    }

    # Split and clean lines
    lines = [ln.strip() for ln in text.splitlines() if ln.strip()]

    # Check for non-transaction SMS patterns
    non_transaction_patterns = [
        r"کد ورود:", r"رمز اول کارت", r"اشتباه وارد شده است", r"ورود به همراه بانک"
    ]
    if any(re.search(pattern, text) for pattern in non_transaction_patterns):
        return {"error": "The given SMS is not a valid transaction SMS."}

    # Special case: Withdrawal for SMS fees
    if "مبلغ برداشت شده از حساب شما بابت هزینه پیامکهای شش ماهه اول ۱۴۰۳" in text:
        result["transaction_type"] = "برداشت"
        result["expense_or_income"] = "expense"
        result["merchant_name"] = "هزینه پیامکهای شش ماهه اول ۱۴۰۳"
        # Amount and datetime are not specified; leave as None
        # Year 1403 is mentioned, but no specific date
        result["datetime"] = "1403-01-01T00:00:00"  # Default to start of 1403
        return result

    unmatched_lines = []

    for line in lines:
        # Check for account number (e.g., 12345.678.901)
        if re.match(r'\d+\.\d+\.\d+', line):
            result["account_number"] = line
            continue

        # Check for transaction type (purchase or payment)
        if line in ["خرید", "پرداخت"]:
            result["transaction_type"] = line
            result["expense_or_income"] = "expense"
            continue

        # Check for amount with sign (general transactions, e.g., +50,000 or -50,000)
        if re.match(r'^[+-][\d,]+$', line):
            sign = line[0]
            amount_str = line[1:].replace(',', '').strip()
            result["amount_of_transaction"] = int(amount_str)
            result["expense_or_income"] = "income" if sign == "+" else "expense"
            if result["transaction_type"] is None:
                result["transaction_type"] = "انتقال"
            continue

        # Check for balance (e.g., مانده: 1,000,000)
        if "مانده:" in line:
            balance_str = line.split("مانده:")[1].split()[0].replace(',', '')
            result["balance"] = int(balance_str)
            continue

        # Check for card number (e.g., کارت: 1234)
        if "کارت:" in line:
            result["card_number"] = line.split("کارت:")[1].strip()
            continue

        # Check for merchant name (e.g., از: فروشگاه XYZ)
        if "از:" in line and result["transaction_type"] in ["خرید", "پرداخت"]:
            result["merchant_name"] = line.split("از:")[1].strip()
            continue

        # Check for datetime (general transaction, MM/DD_HH:MM)
        if m := re.search(r'(\d{2}/\d{2}_\d{2}:\d{2})', line):
            date_time_str = m.group(1)
            month, day, hour, minute = re.match(r'(\d{2})/(\d{2})_(\d{2}):(\d{2})', date_time_str).groups()
            year = 1404  # Assumed based on original code, adjust if needed
            result["datetime"] = f"{year}-{month}-{day}T{hour}:{minute}:00"
            continue

        # Check for datetime (purchase transaction, YYYY/MM/DD-HH:MM:SS)
        if m := re.search(r'(\d{4}/\d{2}/\d{2}-\d{2}:\d{2}:\d{2})', line):
            date_time_str = m.group(1)
            year, month, day, hour, minute, second = re.match(r'(\d{4})/(\d{2})/(\d{2})-(\d{2}):(\d{2}):(\d{2})', date_time_str).groups()
            result["datetime"] = f"{year}-{month}-{day}T{hour}:{minute}:{second}"
            continue

        # Collect unmatched lines for potential merchant name
        unmatched_lines.append(line)

    # Infer merchant name for purchase/payment only if explicitly unmatched and valid context
    if result["transaction_type"] in ["خرید", "پرداخت"] and result["merchant_name"] is None and unmatched_lines:
        # Only set merchant name if it doesn't look like a number or code
        potential_merchant = unmatched_lines[0]
        if not (re.match(r'^[\d,]+$', potential_merchant) or "رمز:" in potential_merchant):
            result["merchant_name"] = potential_merchant

    # Strict validity checking for non-special transactions
    required_fields = ["account_number", "amount_of_transaction", "balance", "datetime"]
    if result["transaction_type"] in ["خرید", "پرداخت"]:
        required_fields.append("merchant_name")

    # Only check required fields if it's not the special SMS fee case
    if not (result["transaction_type"] == "برداشت" and result["merchant_name"] == "هزینه پیامکهای شش ماهه اول ۱۴۰۳"):
        if not all(result[field] is not None for field in required_fields):
            return {"error": "The given SMS is not a valid transaction SMS."}

    return result

# This block allows the script to be called with arguments from Flutter
if __name__ == '__main__':
    # Read the SMS text from the first command-line argument
    if len(sys.argv) > 1:
        sms_text = sys.argv[1]
        parsed_data = parse_resalat_sms(sms_text)
        print(json.dumps(parsed_data)) # Print the result as JSON
    else:
        print(json.dumps({"error": "No SMS text provided as argument to Python script."}))