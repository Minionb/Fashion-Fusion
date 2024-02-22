import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class LikeButton extends StatefulWidget {
  bool isFavorite;

  LikeButton({
    Key? key,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(sl<SharedPreferences>().getString("userID"));
        

        setState(() {
          widget.isFavorite = !widget.isFavorite;
        });
        _controller.reverse().then((value) => _controller.forward());
      },
      child: ScaleTransition(
        scale: Tween(begin: 0.7, end: 1.0).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
        child: widget.isFavorite
            ? Icon(
                Icons.favorite,
                color: AppColors.primary,
                size: 16.sp,
              )
            : Icon(
                Icons.favorite_border,
                size: 16.sp,
                color: AppColors.grayDK,
              ),
      ),
    );
  }
}
