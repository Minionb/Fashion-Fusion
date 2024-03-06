import 'package:fashion_fusion/data/cart/model/cart_item_model.dart';
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

  double getGstAmount(){
    return getSubTotalAmount() * gstPercentage / 100;
  }

  double getTotalAmount(){
    return getSubTotalAmount() + getGstAmount();
  }

  String getFormattedAmount(double amount){
    return NumberFormat("#,##0.00", "en_US").format(amount);
  }

  String getFormattedSubtotalAmount() {
    return getFormattedAmount(getSubTotalAmount());
  }

  String getFormattedGstAmount(){
    return getFormattedAmount(getGstAmount());
  }

  String getFormattedTotalAmount(){
    return getFormattedAmount(getTotalAmount());
  }

}
