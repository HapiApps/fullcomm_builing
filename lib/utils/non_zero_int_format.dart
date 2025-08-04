import 'package:flutter/services.dart';

class StrictNonZeroIntFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty) return newValue;

    // Only allow digits
    if (!RegExp(r'^\d+$').hasMatch(text)) {
      return oldValue;
    }

    // Disallow if starts with 0
    if (text.startsWith('0')) {
      return oldValue;
    }

    return newValue;
  }
}
