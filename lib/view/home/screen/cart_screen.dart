import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/core/widgets/cart_button.dart';
import 'package:fashion_fusion/data/cart/model/cart_item_model.dart';
import 'package:fashion_fusion/view/home/screen/checkout_screen.dart';
import 'package:fashion_fusion/view/home/widget/app_bar.dart';
import 'package:fashion_fusion/view/home/widget/empty_list_widget.dart';
import 'package:fashion_fusion/view/home/widget/list_tile_product_image.dart';
import 'package:fashion_fusion/view/home/widget/total_amount_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> _fetchCartItems() async {
    setState(() {
      context.read<CartCubit>().getCartItems();
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
            return _buildShoppingCartBody();
          } else if (state is CartLoadedState) {
            cartItems = state.models;
            return _buildShoppingCartBody();
          } else {
            return RefreshIndicator(
                onRefresh: () async {
                  _fetchCartItems();
                },
                child: const Center(
                  child: CircularProgressIndicator(),
                ));
          }
        })),
      ),
    ));
  }

  RefreshIndicator _buildShoppingCartBody() {
    Widget cartBody;
    if (cartItems.isNotEmpty) {
      cartBody = _buildShoppingCartItems();
    } else {
      cartBody = const EmptyListWidget(text: "No items in shopping cart.");
    }
    return RefreshIndicator(
      onRefresh: () async {
        _fetchCartItems();
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

  ListView _buildShoppingCartItems() {
    List<CartItemWidget> cartItemWidgets = cartItems.map((item) => CartItemWidget(model: item)).toList();
    return ListView(
      children: [
        ...cartItemWidgets,
        const SizedBox(height: 16),
        const CouponCodeField(),
        const SizedBox(height: 16),
        TotalAmountWidget(cartItems: cartItems),
        const SizedBox(height: 16),
        CheckoutButton(cartItems: cartItems),
      ],
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItemModel model;

  const CartItemWidget({super.key, required this.model});

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
        leading: ListTileImageWidget(
          imageId: model.imageId,
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
                    productId: model.productId, animateCondition: () => false),
                const SizedBox(width: 16),
                Text(model.quantity.toString()), // Quantity
                const SizedBox(width: 16),
                AddCartButton(
                    productId: model.productId, animateCondition: () => false),
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


class CheckoutButton extends StatelessWidget {
  final List<CartItemModel> cartItems;
  const CheckoutButton({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderCheckoutScreen(cartItems: cartItems),
          ),
        );
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
