
import 'package:flutter/material.dart';

class OrderUtils {

  static Color getColorBasedOnStatus(String status) {
    Color textColor = Colors.black; // Default color
    if (status.toLowerCase() == "pending" ||
        status.toLowerCase() == "out for delivery") {
      textColor = const Color.fromARGB(
          255, 255, 94, 0); // Set title color to orange for Pending status
    } else if (status.toLowerCase() == "delivered") {
      textColor = const Color.fromARGB(
          255, 0, 164, 5); // Set title color to green for Delivered status
    } else if (status.toLowerCase() == "cancelled") {
      textColor = Colors.grey; // Set title color to grey for Cancelled status
    }
    return textColor;
  }
  
}