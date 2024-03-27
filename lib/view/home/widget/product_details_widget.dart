import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/widgets/cart_button.dart';
import 'package:fashion_fusion/core/widgets/like_button.dart';
import 'package:fashion_fusion/data/product/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailWidget extends StatefulWidget {
  
  final ProductModel model;
  final bool isFavorite;

  const ProductDetailWidget({super.key, required this.model,
    required this.isFavorite,});

  @override
  State<StatefulWidget> createState() {
    return ProductDetailWidgetState();
  }
}

class ProductDetailWidgetState extends State<ProductDetailWidget> {

  late int xsQuantity = 0;
  late int sQuantity = 0;
  late int mQuantity = 0;
  late int lQuantity = 0;
  late int xlQuantity = 0;

  @override
  void initState() {
    super.initState();
    initialize();
  }


  void initialize() {
    setState(() {
    xsQuantity = checkSizeQuantity("XS");
    sQuantity = checkSizeQuantity("S");
    mQuantity = checkSizeQuantity("M");
    lQuantity = checkSizeQuantity("L");
    xlQuantity = checkSizeQuantity("XL");
    });
  }
  
  int checkSizeQuantity (String size) {
    var inventory = widget.model.inventory;
    int sizeQuantity = 0;
    for (var item in inventory!) {
      if (item.size == size) {
        sizeQuantity = item.quantity!;
        
        return sizeQuantity;
      }
    }
    return sizeQuantity;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text("Product Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cursolImages(),
            Padding(
              padding: const EdgeInsets.all(15.0).w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          widget.model.productName ?? "",
                          style: TextStyle(
                            color: const Color(0xFF222222),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        child: Text(
                          '\$${widget.model.price}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: const Color(0xFF222222),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    widget.model.category ?? "",
                    style: const TextStyle(
                      color: Color(0xFF9B9B9B),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${widget.model.productDescription}",
                    style: const TextStyle(
                      color: Color(0xFF222222),
                      fontSize: 14,
                      fontFamily: 'Metropolis',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (widget.model.category != "Accessories")
                  Row(
                    children: [
                       
                      _buildSizeButton('XS', xsQuantity),
                      _buildSizeButton('S', sQuantity),
                      _buildSizeButton('M', mQuantity),
                      _buildSizeButton('L', lQuantity),
                      _buildSizeButton('XL', xlQuantity),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildSizeButton(String size, int sizeQuantity) {
  final bool isClickable = sizeQuantity > 0;

  return Container(
    margin: const EdgeInsets.only(right: 8),
    child: ElevatedButton(
      onPressed: isClickable
          ? () {
              // Handle button press
              print("$size pressed");
            }
          : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        backgroundColor: isClickable ? Colors.blue : Colors.grey, // Change button color based on clickability
      ),
      child: Text(
        size,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    ),
  );
}

  SizedBox _cursolImages() {
    return SizedBox(
      width: double.infinity,
      child: FlutterCarousel(
        options: CarouselOptions(
          viewportFraction: 1,
          showIndicator: true,
          slideIndicator: const CircularSlideIndicator(),
        ),
        items: widget.model.images?.map((i) {
          final image = "http://127.0.0.1:3000/products/images/$i";
          return Builder(
            builder: (BuildContext context) {
              return SizedBox(
                width: 1.sw,
                child: Image.network(
                  image,
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}