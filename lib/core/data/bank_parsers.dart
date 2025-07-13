import 'package:hesabo_chat_ai/core/data/parsian_parser.dart';
import 'package:hesabo_chat_ai/core/data/pasargad_parser.dart';
import 'package:hesabo_chat_ai/core/data/resalat_parser.dart';
import 'package:hesabo_chat_ai/core/data/saderat_parser.dart';
import 'package:hesabo_chat_ai/core/data/saman_parser.dart';
import 'package:hesabo_chat_ai/core/data/sarmaye_parser.dart';
import 'package:hesabo_chat_ai/core/data/sepah_parser.dart';
import 'package:hesabo_chat_ai/core/data/shahr_parser.dart';
import 'package:hesabo_chat_ai/core/data/sina_parser.dart';
import 'package:hesabo_chat_ai/core/data/tejarat_parser.dart';
import 'package:hesabo_chat_ai/core/data/wepod_parser.dart';
import 'ayandeh_parser.dart';
import 'bank_sms_model.dart';
import 'blu_parser.dart';
import 'iranzamin_parser.dart';
import 'karafarin_parser.dart';
import 'maskan_parser.dart';
import 'mellat_parser.dart';
import 'melli_parser.dart';

class BankSmsParserDispatcher {
  /// A map of bank names (lowercase) to their respective SMS parser functions.
  /// Each parser function should take a String (SMS text) and return a BankSmsModel.
  static const Map<String, BankSmsModel Function(String)> _bankParsers = {
    "ayandeh": AyandehSmsParser.parseAyandehSms,
    "maskan": MaskanSmsParser.parseMaskanSms,
    "resalat": ResalatSmsParser.parseResalatSms,
    "saderat": SaderatSmsParser.parseSaderatSms,
    "melli": MelliSmsParser.parseMelliSms,
    "pasargad": PasargadSmsParser.parsePasargadSms,
    "blue": BlueSmsParser.parseBlueSms,
    "karafarin": KarafarinSmsParser.parseKarafarinSms,
    "mellat": MellatSmsParser.parseMellatSms,
    "sepah": SepahSmsParser.parseSepahSms,
    "shahr": ShahrSmsParser.parseShahrSms,
    "saman": SamanSmsParser.parseSamanSms,
    "tejarat": TejaratSmsParser.parseTejaratSms,
    "sina": SinaSmsParser.parseSinaSms,
    "iranzamin": IranZaminSmsParser.parseIranZaminSms,
    "parsian": ParsianSmsParser.parseParsianSms,
    "sarmayeh": SarmayehSmsParser.parseSarmayehSms,
    "wepod": WepodSmsParser.parseWepodSms,
  };

  /// Parses an SMS transaction from a specified bank into a BankSmsModel.
  ///
  /// This acts as a dispatcher, calling the appropriate bank-specific parser
  /// based on the provided bank name.
  ///
  /// Args:
  ///     bankName (String): The name of the bank (e.g., 'ayandeh', 'maskan', 'wepod').
  ///     text (String): The SMS text to parse.
  ///
  /// Returns:
  ///     BankSmsModel: Parsed transaction details if valid, otherwise a model with an error.
  static BankSmsModel parseBankSms(String bankName, String text) {
    // Look up the parser function for the given bank name (case-insensitive)
    final parser = _bankParsers[bankName.toLowerCase()];

    if (parser == null) {
      return BankSmsModel(
        error: "No parser found for bank: $bankName",
      );
    }

    // Call the found parser function and return its result
    return parser(text);
  }
}