import 'package:fashion_fusion/api/end_points.dart';
import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/core/widgets/cart_button.dart';
import 'package:fashion_fusion/data/cart/model/cart_item_model.dart';
import 'package:fashion_fusion/view/home/widget/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../provider/cart_cubit/cart/cart_cubit.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int catIndex = 0;
  late List<CartItemModel> cartItems;

  Future<void> _fetchCartItems(CartCubit cartCubit) async {
    setState(() {
      cartCubit.getCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return HelperMethod.loader(
        child: Scaffold(
      body: SafeArea(
        bottom: false,
        child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return <Widget>[
            const HomescreenAppBar(title: "Shopping Cart"),
          ];
        }, body: BlocBuilder<CartCubit, CartState>(builder: (context, state) {
          if (state is CartSuccessState) {
            cartItems = state.models;
            return _buildShoppingCartBody(cartItems
                .map((item) => CartItemWidget(
                      model: item,
                    ))
                .toList());
          } else if (state is CartLoadedState) {
            cartItems = state.models;
            return _buildShoppingCartBody(
                cartItems.map((item) => CartItemWidget(model: item)).toList());
          } else {
            return RefreshIndicator(
                onRefresh: () async {
                  _fetchCartItems(context.read<CartCubit>());
                },
                child: const Center(
                  child: CircularProgressIndicator(),
                ));
          }
        })),
      ),
    ));
  }

  RefreshIndicator _buildShoppingCartBody(
      List<CartItemWidget> cartItemWidgets) {
    Widget cartBody;
    if (cartItemWidgets.isNotEmpty) {
      cartBody = _buildShoppingCartItems(cartItemWidgets);
    } else {
      cartBody = const Text("No items in cart");
    }
    return RefreshIndicator(
      onRefresh: () async {
        _fetchCartItems(context.read<CartCubit>());
      },
      child: AnimationLimiter(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0), // Add padding
            child: cartBody,
          ),
        ),
      ),
    );
  }

  ListView _buildShoppingCartItems(List<CartItemWidget> cartItemWidgets) {
    return ListView(
      children: [
        ...cartItemWidgets,
        const SizedBox(height: 16),
        const CouponCodeField(),
        const SizedBox(height: 16),
        TotalAmountWidget(cartItems: cartItems),
        const SizedBox(height: 16),
        const CheckoutButton(),
      ],
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItemModel model;

  const CartItemWidget({super.key, required this.model});

  String _imageUrl() {
    var imageUrl =
        'https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png';
    if (model.imageId?.isNotEmpty ?? true) {
      imageUrl = EndPoints.getProductImagesByImageId
          .replaceAll(":imageId", model.imageId);
    }
    return imageUrl;
  }

  Widget _productName() {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Add padding
      child: Text(
        model.productName,
        maxLines: 1,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Text _price() {
    return Text(
      "\$${model.price.toStringAsFixed(2)}",
      style: TextStyle(color: AppColors.textGray),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGray), // Add border
        borderRadius: BorderRadius.circular(8.0), // Add border radius
      ),
      margin: const EdgeInsets.only(bottom: 16.0), // Add margin
      child: ListTile(
        leading: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
          ),
          clipBehavior: Clip.hardEdge,
          child: Image.network(
            _imageUrl(),
            width: 80,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _productName(),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 16),
                RemoveCartButton(
                  productId: model.productId,
                ),
                const SizedBox(width: 16),
                Text(model.quantity.toString()), // Quantity
                const SizedBox(width: 16),
                AddCartButton(productId: model.productId),
              ],
            ),
            _price(),
          ],
        ),
      ),
    );
  }
}

class CouponCodeField extends StatelessWidget {
  const CouponCodeField({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter coupon code',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          color: AppColors.primary,
          onPressed: () {
            // Check coupon code logic
          },
        ),
      ],
    );
  }
}

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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total:',
          style: TextStyle(
              fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey),
        ),
        Text(
          '\$${totalAmount.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class CheckoutButton extends StatelessWidget {
  const CheckoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Checkout logic
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary, // Set button color
        textStyle: const TextStyle(fontSize: 18), // Set text style
      ),
      child: const Text(
        'Checkout',
        style: TextStyle(color: Colors.white), // Set text color
      ),
    );
  }
}
