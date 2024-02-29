import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/widgets/like_button.dart';
import 'package:fashion_fusion/view/home/screen/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  final bool? isFav;
  const ProductCard({
    super.key,
    required this.model,
    this.isFav,
  });

  final ProductModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: _image(context)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0).w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.verticalSpace,
                _label(),
                7.verticalSpace,
                Row(
                  children: [_price(), const Spacer(), _addPacket()],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

// Method to create the add packet button
  Container _addPacket() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration:
          const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
      child: Icon(
        CupertinoIcons.add,
        color: Colors.white,
        size: 18.sp,
      ),
    );
  }

// Method to create the price text widget
  Text _price() {
    return Text(
      "\$${model.price.toStringAsFixed(2)}",
      style: TextStyle(color: AppColors.textGray),
    );
  }

// Method to create the label text widget
  Text _label() {
    return Text(
      model.label,
      maxLines: 1,
      textAlign: TextAlign.left,
      // overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }

// Method to create the image widget
  ClipRRect _image(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12).w,
      child: Stack(
        children: [
          Image.asset(
            model.imagePath,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            width: double.infinity,
          ),
          // Adding a like button at the top right corner of the image
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                  padding: const EdgeInsets.all(4).w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.bg,
                  ),
                  child: LikeButton(productId: model.id)),
            ),
          )
        ],
      ),
    );
  }
}
