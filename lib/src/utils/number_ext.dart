import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final idrFormat = NumberFormat.currency(
  name: "IDR",
  locale: 'in_ID',
  decimalDigits: 0, // change it to get decimal places
  symbol: 'Rp ',
);

extension DoubleFormatter on double? {
  String inRupiah() {
    return idrFormat.format(this ?? 0);
  }
}

extension IntegerFormatter on int? {
  String inRupiah() {
    return idrFormat.format(this ?? 0);
  }
}

class NoLeadingZeroTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty && newValue.text.startsWith('0')) {
      return TextEditingValue(
        text: newValue.text.replaceFirst('0', ''),
        selection: newValue.selection.copyWith(
          baseOffset: newValue.selection.baseOffset - 1,
          extentOffset: newValue.selection.extentOffset - 1,
        ),
      );
    }
    return newValue;
  }
}
