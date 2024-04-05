import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/widgets/cart_button.dart';
import 'package:fashion_fusion/core/widgets/like_button.dart';
import 'package:fashion_fusion/view/home/widget/product_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fashion_fusion/data/product/model/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel model;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.model,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    String imageUrl = '';
    if (model.images != null) {
      imageUrl = "http://127.0.0.1:3000/products/images/${model.images![0]}";
    }

    return GestureDetector(
        onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailWidget(model: model, isFavorite: isFavorite),
                ),
              )
            },
        child: Container(
          decoration: const BoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: _image(imageUrl)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0).w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.verticalSpace,
                    _label(),
                    7.verticalSpace,
                    Row(
                      children: [
                        _price(),
                        const Spacer(),
                        AddCartButton(productId: model.id!, isDark: true)
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

// Method to create the price text widget
  Text _price() {
    return Text(
      "\$${model.price?.toStringAsFixed(2)}",
      style: TextStyle(color: AppColors.textGray),
    );
  }

// Method to create the label text widget
  Text _label() {
    return Text(
      model.productName!,
      //maxLines: 1,
      textAlign: TextAlign.left,
      // overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }

// Method to create the image widget
  ClipRRect _image(String imageUrl) {
    //  ClipRRect _image(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12).w,
      child: Stack(
        children: [
          Image.network(
            imageUrl,
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
                    child: LikeButton(
                      productId: model.id!,
                      isFavorite: isFavorite,
                    )),
              ))
        ],
      ),
    );
  }
}
