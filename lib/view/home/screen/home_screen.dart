import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_images.dart';
import 'package:fashion_fusion/view/home/widget/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int catIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
              return <Widget>[
                _buildAppBar1(),
                _buildAppBar2(),
              ];
            },
            body: GridView.builder(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 50).w,
              itemCount: ProductModel.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.72),
              itemBuilder: (context, index) {
                final model = ProductModel.products[index];
                return ProductCard(model: model);
              },
            )),
      ),
    );
  }

  SliverAppBar _buildAppBar1() {
    return SliverAppBar(
      expandedHeight: 150.sp,
      floating: false,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              leading: const Icon(CupertinoIcons.line_horizontal_3),
              elevation: 0,
              actions: [
                Row(
                  children: [
                    const Icon(CupertinoIcons.search),
                    10.horizontalSpace,
                    const Icon(CupertinoIcons.bell),
                    15.horizontalSpace
                  ],
                )
              ],
            ),
            10.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0).w,
              child: Text(
                "Discover\nYour Best Clothing",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar2() {
    return SliverAppBar(
        pinned: true,
        backgroundColor: AppColors.bg,
        flexibleSpace: Container(
          color: AppColors.bg,
          child: _listCat(),
        ));
  }

  ListView _listCat() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10).w,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: _cat.length,
      separatorBuilder: (context, index) => 5.horizontalSpace,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              catIndex = index;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20).w,
            decoration: BoxDecoration(
                color: catIndex == index ? AppColors.primary : AppColors.bg,
                border: Border.all(
                    color: catIndex == index
                        ? AppColors.bg
                        : AppColors.darkSeliver),
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Text(
                _cat[index],
                style:
                    TextStyle(color: catIndex == index ? Colors.white : null),
              ),
            ),
          ),
        );
      },
    );
  }

  final List<String> _cat = [
    "Bags",
    "Shoes",
    "Tops",
    "Bottoms",
    "Dresses",
    "Accessories",
    "Hats",
    "Jeans",
  ];
}

class ProductModel {
  final String label;
  final String imagePath;
  final double price;

  ProductModel(
      {required this.label, required this.imagePath, required this.price});

  static List<ProductModel> products = [
    ProductModel(
        label: "Double-breasted Trench Coat",
        imagePath: "${AppImages.imagePath}/1.jpeg",
        price: 10.00),
    ProductModel(
        label: "Double-breasted Blazer",
        imagePath: "${AppImages.imagePath}/2.jpeg",
        price: 20.00),
    ProductModel(
        label: "Wide-leg Pants",
        imagePath: "${AppImages.imagePath}/3.jpeg",
        price: 20.00),
    ProductModel(
        label: "Baggy Regular Jeans",
        imagePath: "${AppImages.imagePath}/4.jpeg",
        price: 30.00),
    ProductModel(
        label: "Jacquard-knit Sweater",
        imagePath: "${AppImages.imagePath}/5.jpeg",
        price: 25.00),
    ProductModel(
        label: "Puffer Vest",
        imagePath: "${AppImages.imagePath}/6.jpeg",
        price: 21.00),
    ProductModel(
        label: "Linen-blend Pull-on Pants",
        imagePath: "${AppImages.imagePath}/7.jpeg",
        price: 23.00),
    ProductModel(
        label: "Coated Bomber Jacket",
        imagePath: "${AppImages.imagePath}/8.jpeg",
        price: 5.00),
    ProductModel(
        label: "Linen-blend Pull-on Pants",
        imagePath: "${AppImages.imagePath}/9.jpeg",
        price: 10.00),
    ProductModel(
        label: "MAMA Straight Ankle Jeans",
        imagePath: "${AppImages.imagePath}/10.jpeg",
        price: 13.00),
    ProductModel(
        label: "Long-sleeved Jersey Top",
        imagePath: "${AppImages.imagePath}/11.jpeg",
        price: 14.00),
    ProductModel(
        label: "Curvy Fit Baggy Low Jeans",
        imagePath: "${AppImages.imagePath}/12.jpeg",
        price: 45.00),
  ];
}

enum User { student, instructor, admin }
