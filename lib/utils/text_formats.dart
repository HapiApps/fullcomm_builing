import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextFormat {

  // Responsive FontSize
  static double responsiveFontSize(BuildContext context, double fontSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Adjust the multiplier as needed to balance scaling.
    return fontSize * (screenWidth / 1440); // Assuming 1440 is a typical desktop width.
  }

  // Title Case
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;

    return text.trim().split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  // Date with AM/PM (Oct 21)
  static String formatDateTime(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    String date = DateFormat.yMMMd().format(parsedDate);
    String time = DateFormat('hh:mm a').format(parsedDate);
    return '$date\n$time';
  }

  // Indian Currency Format
  static String formattedAmount(amount) {
    return NumberFormat.currency(
      locale: 'en_IN', // Indian locale for Rupee format
      symbol: '₹', // Currency symbol
      decimalDigits: 1, // Set decimal places
    ).format(amount);
  }


}
