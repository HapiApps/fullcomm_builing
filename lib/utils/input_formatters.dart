import 'package:flutter/services.dart';

class InputFormatters{
  
  static List<TextInputFormatter> mobileNumberInput=[
    LengthLimitingTextInputFormatter(10),
    FilteringTextInputFormatter.digitsOnly,
    FilteringTextInputFormatter.allow(RegExp("[0-9]"))
  ];

  static List<TextInputFormatter> quantityInput=[
    LengthLimitingTextInputFormatter(5),
    FilteringTextInputFormatter.digitsOnly,
    FilteringTextInputFormatter.allow(RegExp("[0-9]"))
  ];

  static List<TextInputFormatter> variationInput = [
    LengthLimitingTextInputFormatter(5),
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
  ];

  static List<TextInputFormatter> pinCodeInput=[
    LengthLimitingTextInputFormatter(6),
    FilteringTextInputFormatter.allow(RegExp("[0-9]"))
  ];

}

