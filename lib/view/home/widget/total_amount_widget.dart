import 'package:fashion_fusion/data/cart/model/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalAmountWidget extends StatelessWidget {
  final List<CartItemModel> cartItems;
  const TotalAmountWidget({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0.0;

    // Calculate total amount
    for (var item in cartItems) {
      totalAmount += (item.price) * item.quantity;
    }
    String formattedTotalAmount =
        NumberFormat("#,##0.00", "en_US").format(totalAmount);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        const Text(
          'Total:',
          style: TextStyle(
              fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey),
        ),
        Text(
          '\$$formattedTotalAmount',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
