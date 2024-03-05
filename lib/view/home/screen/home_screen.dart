import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/app_images.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/provider/favorite_cubit/favorite/favorite_cubit.dart';
import 'package:fashion_fusion/provider/product_cubit/product/product_cubit.dart';
import 'package:fashion_fusion/view/home/widget/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fashion_fusion/data/product/model/product_model.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int catIndex = 0;
  late List<String> _favoriteIds;
  late List<ProductModel> products;

  Future<void> _fetchFavorites(FavoriteCubit favoriteCubit) async {
    setState(() {
      favoriteCubit.getFavorite();
    });
  }

    Future<void> _fetchProducts(ProductCubit productCubit) async {
    setState(() {
      productCubit.getProduct();
    });
  }

    @override
  void initState() {
    super.initState();
    _fetchProducts(context.read<ProductCubit>());
  }

  Widget build(BuildContext context) {
  return HelperMethod.loader(
    child: Scaffold(
      body: SafeArea(
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
            return <Widget>[
              _buildAppBar1(),
              _buildAppBar2(),
            ];
          },
          body: BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    if (state is ProductIsLoadingState) {
                      // Handle loading state if needed
                    } else if (state is ProductLoadedState) {
                      products = state.models;
                      return AnimationLimiter(
                        child: GridView.builder(
                          
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 50),
                          itemCount: products.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: 0.72,
                          ),
                          itemBuilder: (context, index) {
                            final model = products[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 900),
                              child: SlideAnimation(
                                child: FadeInAnimation(
                                  child: ProductCard(model: model),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      // Handle other states if needed
                    }
              // Return a default widget if none of the conditions are met
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
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
    "Tops",
    "Bottoms",
    "Dresses",
    "Hoodies & Sweats",
    "Accessories",
  ];
}


enum User { student, instructor, admin }
