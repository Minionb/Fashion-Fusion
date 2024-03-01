import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/data/favorite/model/put_favorite_model.dart';
import 'package:fashion_fusion/provider/favorite_cubit/favorite_edit/favorite_edit_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddCartButton extends StatefulWidget {
  final bool isDark;
  final String productId;

  const AddCartButton(
      {super.key,
      this.isDark = true,
      required this.productId}); // Updated constructor

  @override
  State<AddCartButton> createState() => _AddCartButtonState();
}

class _AddCartButtonState extends State<AddCartButton>
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
    final favoriteCubit = context.watch<FavoriteEditCubit>();

    // Wrap the widget with BlocBuilder to rebuild the widget based on cubit state changes
    return BlocBuilder<FavoriteEditCubit, FavoriteEditState>(
      builder: (context, state) {
        return GestureDetector(
          // Define onTap callback, executed when the widget is tapped
          onTap: () {
            print("Add to Cart Tapped");
            // Reverse the animation controller and then forward it to trigger the scale animation
            _controller.reverse().then((value) => _controller.forward());
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
                    ? Icon(Icons.add_shopping_cart,
                        color: Colors.white, size: 16.sp)
                    : Icon(
                        Icons.add_shopping_cart,
                        size: 16.sp,
                        color: AppColors.grayDK,
                      ),
              )),
        );
      },
    );
  }
}
