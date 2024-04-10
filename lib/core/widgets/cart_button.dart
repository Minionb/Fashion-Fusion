import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/data/cart/model/put_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../provider/cart_cubit/cart_cubit.dart';

abstract class CartButton extends StatefulWidget {
  final bool isDark;
  final IconData icon;
  final double? iconSize;
  final int quantityUpdate;
  final bool Function() animateCondition;
  final String productId;

  const CartButton({
    super.key,
    this.isDark = true,
    required this.icon,
    this.iconSize,
    required this.quantityUpdate,
    this.animateCondition = _defaultOnTapCondition,
    required this.productId,
  });

  static bool _defaultOnTapCondition() {
    return true;
  }
}

class AddCartButton extends CartButton {
  const AddCartButton(
      {super.key,
      super.isDark,
      super.icon = Icons.add,
      super.iconSize = 16,
      super.quantityUpdate = 1,
      super.animateCondition,
      required super.productId}); // Updated constructor

  @override
  State<CartButton> createState() => _CartButtonState();
}

class RemoveCartButton extends CartButton {
  const RemoveCartButton({
    super.key,
    super.isDark = true,
    super.icon = Icons.remove,
    super.iconSize = 16,
    super.quantityUpdate = -1,
    super.animateCondition,
    required super.productId,
  }); // Updated constructor

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 200), vsync: this, value: 1.0);

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // Override the build method to define how the widget should be built
  @override
  Widget build(BuildContext context) {
    // Access the FavoriteEditCubit instance
    final cartCubit = context.watch<CartCubit>();

    // Wrap the widget with BlocBuilder to rebuild the widget based on cubit state changes
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return GestureDetector(
          // Define onTap callback, executed when the widget is tapped
          onTap: () {
            cartCubit.putCartItems(PutCartItemModel(
                productId: widget.productId, quantity: widget.quantityUpdate));
            if (widget.animateCondition()) {
              // Reverse the animation controller and then forward it to trigger the scale animation
              _controller.reverse().then((value) => {_controller.forward()});
            }
          },
          // Child widget wrapped with ScaleTransition for scaling animation
          child: ScaleTransition(
              // Define scale animation using Tween animation
              scale: Tween(begin: 0.7, end: 1.0).animate(
                  CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
              // Child of ScaleTransition, displays either filled or outline heart icon based on isFavorite
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: widget.isDark
                    ? const BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle)
                    : const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                child: widget.isDark
                    ? Icon(widget.icon,
                        color: Colors.white, size: widget.iconSize)
                    : Icon(
                        widget.icon,
                        size: widget.iconSize,
                        color: AppColors.grayDK,
                      ),
              )),
        );
      },
    );
  }
}
