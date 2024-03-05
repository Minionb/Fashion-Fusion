import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/cart_decorator_utils.dart';
import 'package:fashion_fusion/data/cart/model/cart_item_model.dart';
import 'package:fashion_fusion/view/home/widget/list_tile_product_image.dart';
import 'package:fashion_fusion/view/home/widget/total_amount_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderCheckoutScreen extends StatelessWidget {
  final List<CartItemModel> cartItems;
  final CartDecorator cartDecorator;
  const OrderCheckoutScreen({super.key, required this.cartItems, required this.cartDecorator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Checkout",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Order Summary',
              content: _buildShoppingCartItems(),
              initiallyExpanded: true
            ),
            _buildSection(
              title: 'Payment Options',
              content: _buildPaymentOptions(),
            ),
            _buildSection(
              title: 'Shipping Details',
              content: _buildShippingDetails(),
            ),
            const SizedBox(height: 30),
            const PlaceOrderButton(),
          ],
        ),
      ),
    );
  }

Widget _buildSection({required String title, required Widget content, bool initiallyExpanded = false}) {
  return ExpansionTile(
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    initiallyExpanded: initiallyExpanded,
    children: [content],
  );
}


  Widget _buildShoppingCartItems() {
    var cartItemWidgets = cartItems
        .map((item) => CartItemWidget(
              model: item,
            ))
        .toList();
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ...cartItemWidgets,
        const SizedBox(height: 16),
        CartCheckoutAmountWidget(label: 'Subtotal Amount', value: cartDecorator.getFormattedSubtotalAmount()),
        const SizedBox(height: 16),
        CartCheckoutAmountWidget(label: 'GST/HST', value: cartDecorator.getFormattedGstAmount()),
        const SizedBox(height: 16),
        CartCheckoutAmountWidget(label: 'Total Amount', value: cartDecorator.getFormattedTotalAmount(), isHighlight: true,),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPaymentOptions() {
    // TODO: Implement the UI for payment options
    return const Text('Payment Options');
  }

  Widget _buildShippingDetails() {
    // TODO: Implement the UI for shipping details
    return const Text('Shipping Details');
  }
}


class CartItemWidget extends StatelessWidget {
  final CartItemModel model;

  const CartItemWidget({super.key, required this.model});

  Widget _productName() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        model.productName,
        maxLines: 1,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ))
    ;
  }

  Text _price() {
    var subtotal = model.price * model.quantity;
    return Text(
          "\$${fomattedPrice(subtotal)}",
          style: TextStyle(color: AppColors.textGray),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGray), // Add border
        borderRadius: BorderRadius.circular(8.0), // Add border radius
      ),
      margin: const EdgeInsets.only(bottom: 16.0), // Add margin
      child: ListTile(
        leading: ListTileImageWidget(
          imageId: model.imageId,
        ),
        title: _productName(),
        subtitle: 
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(model.quantity.toString()), // Quantity
                const SizedBox(width: 16),
                const Text('x'), // Quantity
                const SizedBox(width: 16),
                Text("\$${fomattedPrice(model.price)}")
              ],
            ),
            const Text("="),
            _price(),
          ],
          ),
      ));
    
  }

  String fomattedPrice(double price){
    return NumberFormat("#,##0.00", "en_US").format(price);
  }
}
class PlaceOrderButton extends StatelessWidget {
  const PlaceOrderButton({Key? key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Add functionality for placing order
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, // Set button color
              textStyle: const TextStyle(fontSize: 18), // Set text style
            ),
            child: const Text(
              'Place Order',
              style: TextStyle(color: Colors.white), // Set text color
            ),
          ),
        ),
      ],
    );
  }
}
