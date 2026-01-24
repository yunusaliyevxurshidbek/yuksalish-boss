import 'package:flutter/services.dart';

/// Formats phone numbers with automatic spacing
/// Example: +998 90 123 45 67
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters except +
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d+]'), '');

    // If empty, return empty
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Build formatted string
    final StringBuffer formatted = StringBuffer();
    int digitIndex = 0;

    for (int i = 0; i < digitsOnly.length; i++) {
      final char = digitsOnly[i];

      // Handle + at start
      if (char == '+' && i == 0) {
        formatted.write('+');
        continue;
      }

      // Add spacing based on position
      // Format: +998 90 123 45 67
      // Positions: +XXX XX XXX XX XX
      if (digitIndex == 3 || digitIndex == 5 || digitIndex == 8 || digitIndex == 10) {
        formatted.write(' ');
      }

      formatted.write(char);
      digitIndex++;

      // Limit to 12 digits (998 90 123 45 67)
      if (digitIndex >= 12) break;
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
        if (RegExp(r'[\d+]').hasMatch(newValue.text[i])) {
          targetDigits++;
        }
      }

      // Find position in formatted string with same number of digits
      for (int i = 0; i < formattedText.length; i++) {
        if (digitsSeen >= targetDigits) {
          newCursorPosition = i;
          break;
        }
        if (RegExp(r'[\d+]').hasMatch(formattedText[i])) {
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
