import 'package:flutter/material.dart';

class CartCheckoutAmountWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  static const double fontSizeNonHighlight = 16;
  static const double fontSizeHighlight = 18;
  const CartCheckoutAmountWidget(
      {super.key,
      this.isHighlight = false,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isHighlight
              ? const TextStyle(fontSize: fontSizeHighlight, fontWeight: FontWeight.bold)
              : const TextStyle(fontSize: fontSizeNonHighlight),
        ),
        Text(
          '\$$value',
          style: isHighlight
              ? const TextStyle(fontSize: fontSizeHighlight, fontWeight: FontWeight.bold)
              : const TextStyle(fontSize: fontSizeNonHighlight),
        ),
      ],
    );
  }
}
