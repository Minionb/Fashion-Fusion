import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/view/home/screen/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.model,
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
          Expanded(child: _image()),
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

  Text _price() {
    return Text(
      "\$${model.price.toStringAsFixed(2)}",
      style: TextStyle(color: AppColors.textGray),
    );
  }

  Text _label() {
    return Text(
      model.label,
      maxLines: 1,
      textAlign: TextAlign.left,
      // overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }

  ClipRRect _image() {
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
                child: Icon(
                  CupertinoIcons.heart,
                  size: 16.sp,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
