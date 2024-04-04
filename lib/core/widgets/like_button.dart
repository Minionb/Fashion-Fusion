import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/data/favorite/model/put_favorite_model.dart';
import 'package:fashion_fusion/provider/favorite_cubit/favorite_edit/favorite_edit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class LikeButton extends StatefulWidget {
  bool isFavorite;
  bool isDark;
  final String productId;
  final Function(bool isLiked) onLikeStatusChanged;
  final double? iconSize; // Callback function

  LikeButton(
      {super.key,
      this.isFavorite = false,
      this.isDark = false,
      required this.productId,
      this.iconSize = 16,
      this.onLikeStatusChanged =
          _defaultOnLikeStatusChanged}); // Updated constructor

  @override
  State<LikeButton> createState() => _LikeButtonState();
  // Default function for onLikeStatusChanged
  static void _defaultOnLikeStatusChanged(bool isLiked) {
    // No operation
  }
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 200), vsync: this, value: 1.0);

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // Method to toggle favorite status
  Future<void> toggleFavoriteStatus(FavoriteEditCubit favoriteCubit) async {
    var putDeleteFavoriteModel =
        PutDeleteFavoriteModel(productId: widget.productId);
    if (widget.isFavorite) {
      // If the item is already a favorite, delete it
      favoriteCubit.deleteFavorite(putDeleteFavoriteModel);
    } else {
      // If the item is not a favorite, add it
      favoriteCubit.putFavorite(putDeleteFavoriteModel);
    }

    // Toggle the value of isFavorite when tapped
    setState(() {
      widget.isFavorite = !widget.isFavorite;
    });

    // Notify the parent widget about the change in like status
    widget.onLikeStatusChanged(widget.isFavorite);
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
            toggleFavoriteStatus(favoriteCubit);

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
                // decoration: widget.isDark
                //     ? const BoxDecoration(
                //         color: Colors.black, shape: BoxShape.circle)
                //     : const BoxDecoration(
                //         color: Colors.white, shape: BoxShape.circle),
                child: _buildIFavoriteIcon(),
              )),
        );
      },
    );
  }

  Icon _buildIFavoriteIcon() {
    if (widget.isFavorite) {
      return Icon(
                      Icons.favorite,
                      color: AppColors.primary,
                      size: widget
                          .iconSize, // Size of the icon in scaled pixels
                    );
    } else {
      // if (widget.isDark) {
      //   return Icon(
      //                 Icons.favorite,
      //                 size: widget.iconSize,
      //                 color: AppColors.whiteDK,
      //               );
      // } else {
        return Icon(
                      Icons.favorite_border_outlined,
                      size: widget.iconSize,
                      color: AppColors.grayDK,
                    );
      // }
    }
  }
}
