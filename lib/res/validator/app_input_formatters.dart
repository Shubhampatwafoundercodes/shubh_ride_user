import 'package:flutter/services.dart';

/// Custom formatter to convert input to uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class AppInputFormatters {
  /// Digits only
  static List<TextInputFormatter> digitsOnly = [
    FilteringTextInputFormatter.digitsOnly,
  ];

  /// Letters and spaces only
  static List<TextInputFormatter> nameOnly = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
    LengthLimitingTextInputFormatter(40),
  ];

  /// Alphanumeric + email symbols
  static List<TextInputFormatter> email = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._\-]')),
    LengthLimitingTextInputFormatter(40),

  ];

  /// Alphanumeric only (no special characters)
  static List<TextInputFormatter> alphanumeric = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
  ];

  /// PAN format - 10 uppercase alphanumeric characters
  static List<TextInputFormatter> pan = [
    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
    UpperCaseTextFormatter(),
    LengthLimitingTextInputFormatter(10),
  ];

  /// IFSC format - 11 uppercase alphanumeric characters
  static List<TextInputFormatter> ifsc = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
    UpperCaseTextFormatter(),
    LengthLimitingTextInputFormatter(11),
  ];

  /// Aadhaar - 12 digit numeric
  static List<TextInputFormatter> aadhaar = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(12),
  ];

  /// Account number - max 18 digits
  static List<TextInputFormatter> accountNumber = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(18),
  ];
  ///amount res
  static List<TextInputFormatter> amount = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(5),
  ];
  static List<TextInputFormatter> bankName = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
    UpperCaseTextFormatter(),
    LengthLimitingTextInputFormatter(50),
  ];
}
