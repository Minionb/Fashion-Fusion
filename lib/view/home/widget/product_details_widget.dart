import 'package:fashion_fusion/config/theme/app_theme.dart';
import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/core/widgets/like_button.dart';
import 'package:fashion_fusion/data/cart/model/put_item_model.dart';
import 'package:fashion_fusion/data/product/model/product_model.dart';
import 'package:fashion_fusion/provider/cart_cubit/cart_cubit.dart';
import 'package:fashion_fusion/provider/favorite_cubit/favorite/favorite_cubit.dart';
import 'package:fashion_fusion/provider/favorite_cubit/favorite_edit/favorite_edit_cubit.dart';
import 'package:fashion_fusion/provider/product_cubit/product/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailWidget extends StatefulWidget {
  final ProductModel model;
  final bool isFavorite;

  const ProductDetailWidget({
    super.key,
    required this.model,
    required this.isFavorite,
  });

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

  int checkSizeQuantity(String size) {
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoriteCubit>(
          create: (context) => sl<FavoriteCubit>()..getFavorite(),
        ),
        BlocProvider<FavoriteEditCubit>(
          create: (context) => sl<FavoriteEditCubit>(),
        ),
        BlocProvider<CartCubit>(
          create: (context) => sl<CartCubit>(),
        ),
      ],
      child: Scaffold(
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
                padding: const EdgeInsets.all(16.0),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "${widget.model.productDescription}",
                      style: const TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 16,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.15,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildButtonRow(context)
                    // if (widget.model.category != "Accessories")
                    //   _buildSizeSelection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildButtonRow(BuildContext buildContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: AddToCartButtonState(productModel: widget.model),
        ),
        const SizedBox(width: 16,),
        BlocConsumer<FavoriteCubit, FavoriteState>(
          listener: (context, productState) {
            // When products are loaded, get favorite products
            if (productState is ProductLoadedState) {
              context.read<FavoriteCubit>().getFavorite();
            }
          },
          builder: (BuildContext context, FavoriteState state) {
            return LikeButton(
              productId: widget.model.id!,
              isDark: true,
              iconSize: 30,
            );
          },
        )
      ],
    );
  }

  Row _buildSizeSelection() {
    return Row(
      children: [
        _buildSizeButton('XS', xsQuantity),
        _buildSizeButton('S', sQuantity),
        _buildSizeButton('M', mQuantity),
        _buildSizeButton('L', lQuantity),
        _buildSizeButton('XL', xlQuantity),
      ],
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
          backgroundColor: isClickable
              ? Colors.blue
              : Colors.grey, // Change button color based on clickability
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
          return SizedBox(
            width: 1.sw,
            child: Image.network(
              image,
              width: double.infinity,
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class AddToCartButtonState extends StatelessWidget{
  final ProductModel productModel;

  const AddToCartButtonState({super.key, required this.productModel});

  // Override the build method to define how the widget should be built
  @override
  Widget build(BuildContext context) {
    final cartCubit = context.watch<CartCubit>();
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return GestureDetector(
          // Define onTap callback, executed when the widget is tapped
          onTap: () {
            cartCubit.putCartItems(PutCartItemModel(
                productId: productModel.id!, quantity: 1));
          },
          // Child widget wrapped with ScaleTransition for scaling animation
          child: ElevatedButton(
            onPressed: () {
              cartCubit.putCartItems(
                  PutCartItemModel(
                      productId: productModel.id!,
                      quantity: 1));
            },
            style: AppTheme.primaryButtonStyle(),
            child: const Text('Add to Cart',
                style: TextStyle(color: Colors.white)),
          ),
        );
      },
    );
  }
}
