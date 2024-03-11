import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/widgets/cart_button.dart';
import 'package:fashion_fusion/data/cart/model/cart_item_model.dart';
import 'package:fashion_fusion/view/home/widget/list_tile_product_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel model;
  final bool readOnly;

  const CartItemWidget(
      {super.key, required this.model, required this.readOnly});

  Widget _productName() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          model.productName,
          maxLines: 2,
          textAlign: TextAlign.left,
          overflow: TextOverflow.fade,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
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
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGray), // Add border
          borderRadius: BorderRadius.circular(8.0), // Add border radius
        ),
        child: ListTile(
          leading: ListTileImageWidget(
            imageId: model.imageId,
          ),
          title: Row(children: [_productName()]),
          subtitle: _buildSubtitle(),
        ));
  }

  Widget _buildSubtitle() {
    if (readOnly) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildReadonlyPriceAndQuantity(),
          _buildSubtotalItem(),
        ],
      );
    } else {
      return Column(
        children: [
          _buildEditablePriceAndQuantity(),
          _buildSubtotalItem(),
        ],
      );
    }
  }

  Row _buildEditablePriceAndQuantity() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            RemoveCartButton(
                productId: model.productId, animateCondition: () => false),
            const SizedBox(width: 16),
            Text(model.quantity.toString()),
            const SizedBox(width: 16),
            AddCartButton(
                productId: model.productId, animateCondition: () => false)
          ]),
          const Text('x'), // Quantity
          Text("\$${fomattedPrice(model.price)}")
        ]);
  }

  Row _buildReadonlyPriceAndQuantity() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(model.quantity.toString()), // Quantity
          const SizedBox(width: 16),
          const Text('x'), // Quantity
          const SizedBox(width: 16),
          Text("\$${fomattedPrice(model.price)}")
        ]);
  }

  Row _buildSubtotalItem() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [const Text("= "), const SizedBox(width: 16), _price()]);
  }


  String fomattedPrice(double price) {
    return NumberFormat("#,##0.00", "en_US").format(price);
  }
}
