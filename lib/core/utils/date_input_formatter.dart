import 'package:flutter/services.dart';

/// Formats date input with automatic dots
/// Example: 12041995 -> 12.04.1995
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // If empty, return empty
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Limit to 8 digits (DDMMYYYY)
    if (digitsOnly.length > 8) {
      digitsOnly = digitsOnly.substring(0, 8);
    }

    // Build formatted string
    final StringBuffer formatted = StringBuffer();

    for (int i = 0; i < digitsOnly.length; i++) {
      // Add dot after day (2 digits) and month (4 digits)
      if (i == 2 || i == 4) {
        formatted.write('.');
      }
      formatted.write(digitsOnly[i]);
    }

    final formattedText = formatted.toString();

    // Calculate new cursor position
    int newCursorPosition = formattedText.length;

    // Try to maintain relative cursor position
    if (newValue.selection.baseOffset <= newValue.text.length) {
      final oldCursor = newValue.selection.baseOffset;
      int digitsSeen = 0;
      int targetDigits = 0;

      // Count digits before old cursor
      for (int i = 0; i < oldCursor && i < newValue.text.length; i++) {
        if (RegExp(r'\d').hasMatch(newValue.text[i])) {
          targetDigits++;
        }
      }

      // Find position in formatted string with same number of digits
      for (int i = 0; i < formattedText.length; i++) {
        if (digitsSeen >= targetDigits) {
          newCursorPosition = i;
          break;
        }
        if (RegExp(r'\d').hasMatch(formattedText[i])) {
          digitsSeen++;
        }
        newCursorPosition = i + 1;
      }
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(
        offset: newCursorPosition.clamp(0, formattedText.length),
      ),
    );
  }
}
