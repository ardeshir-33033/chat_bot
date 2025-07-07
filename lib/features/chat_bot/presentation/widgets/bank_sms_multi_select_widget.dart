import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:intl/intl.dart' as intl;

import '../../data/models/chat_bot_question_options.dart';

class BankAccountOption {
  final String label;
  final String svgAsset;
  final String initialValue;
  final int bankId;
  String? accountNumber;
  String? cardNumber;
  String? sheba;

  BankAccountOption({
    required this.label,
    required this.svgAsset,
    required this.initialValue,
    required this.bankId,
    this.accountNumber,
    this.cardNumber,
    this.sheba,
  });
}

class BankAccountMultiSelectWidget extends StatefulWidget {
  final String question;
  final String? description;
  final List<BankAccountOption> options;
  final void Function(List<BankAccountOption>) onSubmit;

  const BankAccountMultiSelectWidget({
    Key? key,
    required this.question,
    this.description,
    required this.options,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<BankAccountMultiSelectWidget> createState() =>
      _BankAccountMultiSelectWidgetState();
}

class _BankAccountMultiSelectWidgetState
    extends State<BankAccountMultiSelectWidget> {
  final Map<int, bool> selected = {};
  final Map<int, TextEditingController> controllers = {};

  @override
  void initState() {
    selected.addAll({
      for (var o in widget.options) widget.options.indexOf(o): true,
    });
    super.initState();
  }

  @override
  void dispose() {
    controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFF23244A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.question,
              style: context.textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.description != null) ...[
              SizedBox(height: 8),
              Text(
                widget.description!,
                style: context.textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF181A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: List.generate(widget.options.length, (i) {
                  final option = widget.options[i];
                  final isChecked = selected[i] ?? true;
                  controllers[i] ??= TextEditingController(
                    text: formatIntToRial(int.parse(option.initialValue)),
                  );
                  return Column(
                    children: [
                      CheckboxListTile(
                        value: isChecked,
                        onChanged: (val) {
                          setState(() {
                            selected[i] = val ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Colors.blueAccent,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        title: Row(
                          children: [
                            SvgPicture.asset(
                              option.svgAsset,
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                option.label,
                                style: context.textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: Focus(
                                child: TextField(
                                  controller: controllers[i],
                                  style: context.textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF22AFFF),
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'مبلغ...',
                                    hintStyle: TextStyle(color: Colors.white54),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 0,
                                    ),
                                  ),
                                  cursorColor: Colors.white,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (i != widget.options.length - 1)
                        Divider(
                          color: Colors.white12,
                          height: 1,
                          thickness: 1,
                          indent: 8,
                          endIndent: 8,
                        ),
                    ],
                  );
                }),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF23244A),
                  side: BorderSide(color: Colors.purpleAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  final result = widget.options
                      .where((o) => selected[widget.options.indexOf(o)]!)
                      .toList();
                  widget.onSubmit(result);
                },
                // selected.values.any((v) => v)
                //     ? () {
                //         final result = widget.options
                //             .where((o) => selected[widget.options.indexOf(o)]!)
                //             .toList();
                //         widget.onSubmit(result);
                //       }
                //     : null,
                child: Text('ادامه', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatIntToRial(int amount) {
    // Create a NumberFormat instance.
    // 'en_US' locale is used to ensure standard thousands separators (e.g., 1,234,567).
    // 'symbol: ""' prevents the formatter from adding any default currency symbol.
    // 'decimalDigits: 0' ensures no decimal places are included, as Rial is typically whole.
    final intl.NumberFormat formatter = intl.NumberFormat.currency(
      locale: 'en_US',
      symbol: '',
      decimalDigits: 0,
    );

    // Format the integer amount using the created formatter.
    final String formattedAmount = formatter.format(amount);

    // Append the Persian word for Rial ("ریال") to the formatted amount.
    return '$formattedAmount ریال';
  }
}
