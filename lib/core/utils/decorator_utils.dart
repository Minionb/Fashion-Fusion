import 'package:fashion_fusion/data/cart/model/cart_item_model.dart';
import 'package:fashion_fusion/data/order/model/order_model.dart';
import 'package:intl/intl.dart';

class CartDecorator {
  final List<CartItemModel> cartItems;
  final double gstPercentage = 13.0;

  CartDecorator({required this.cartItems});

  double getSubTotalAmount() {
    double totalAmount = 0.0;
    for (var item in cartItems) {
      totalAmount += (item.price) * item.quantity;
    }
    return totalAmount;
  }

  double getTaxAmount() {
    return getSubTotalAmount() * gstPercentage / 100;
  }

  double getTotalAmount() {
    return getSubTotalAmount() + getTaxAmount();
  }

  String getFormattedSubtotalAmount() {
    return AppFormatter.getFormattedAmount(getSubTotalAmount());
  }

  String getFormattedTaxAmount() {
    return AppFormatter.getFormattedAmount(getTaxAmount());
  }

  String getFormattedTotalAmount() {
    return AppFormatter.getFormattedAmount(getTotalAmount());
  }
}

class OrderModelDecorator{
  final OrderModel orderModel;

  OrderModelDecorator({required this.orderModel});
  

  String getFormattedSubtotalAmount() {
    return AppFormatter.getFormattedAmount(orderModel.subtotal ?? 0.0);
  }

  String getFormattedTaxAmount() {
    return AppFormatter.getFormattedAmount(orderModel.tax ?? 0.0);
  }

  String getFormattedTotalAmount() {
    return AppFormatter.getFormattedAmount(orderModel.totalAmount ?? 0.0);
  }
}

class AppFormatter {
  static String getFormattedAmount(double amount) {
    return NumberFormat("#,##0.00", "en_US").format(amount);
  }
}
