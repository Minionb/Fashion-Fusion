import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/core/widgets/custom_search_bar.dart';
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
  String cat = "";
  String productName = "";
  Map<String, String> productQueryParams = {
    'category': '',
    'productName': '',
  };
  late List<String> _favoriteIds;
  late List<ProductModel> products;
  TextEditingController searchController = TextEditingController();

  Future<void> _fetchProducts(ProductCubit productCubit) async {
    setState(() {
      productCubit.getProduct(productQueryParams);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts(context.read<ProductCubit>());
  }

  @override
  Widget build(BuildContext context) {
    // HelperMethod.loader is a custom widget that wraps the child with a loader if needed
    return HelperMethod.loader(
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
              // Building app bar widgets
              return <Widget>[
                _buildAppBar1(),
                _buildAppBar2(),
              ];
            },
            body: _buildBody(), // Building the main body of the screen
          ),
        ),
      ),
    );
  }

// Building the main body of the screen
  Widget _buildBody() {
    return Center(
      child: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, productState) {
          // When products are loaded, get favorite products
          if (productState is ProductLoadedState) {
            context.read<FavoriteCubit>().getFavorite();
          }
        },
        builder: (context, productState) {
          // Building UI based on product state
          if (productState is ProductIsLoadingState) {
            // Show loading state
            return _buildLoadingState();
          } else if (productState is ProductLoadedState) {
            // Products are loaded, display products grid
            products = productState.models;
            return _buildProductsGrid();
          } else {
            // If no products loaded, return empty SizedBox
            return const SizedBox();
          }
        },
      ),
    );
  }

// Building loading state widget
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

// Building the products grid
  Widget _buildProductsGrid() {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, favoriteState) {
        if (favoriteState is FavoriteLoadedState) {
          // When favorite products are loaded, extract favorite ids and build products list
          _favoriteIds = favoriteState.models
              .map((model) => model.productId)
              .where((element) => element.isNotEmpty)
              .toList()
              .cast<String>();
          return _buildProductsList();
        } else {
          // If favorite products not loaded, return empty SizedBox
          return const SizedBox();
        }
      },
    );
  }

// Building the products list
  Widget _buildProductsList() {
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
          final bool isFavorite = _favoriteIds.contains(model.id);
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 900),
            child: SlideAnimation(
              child: FadeInAnimation(
                child: ProductCard(
                  model: model,
                  isFavorite: isFavorite,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  SliverAppBar _buildAppBar1() {
    void handleSearchButtonTap() {
      setState(() {
        if (searchController.text != "") {
          productName = "${searchController.text}*";
          productQueryParams = {
            'productName': productName,
          };
        } else {
          productQueryParams = {
            'productName': '',
          };
        }
        _fetchProducts(context.read<ProductCubit>());
      });
    }

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
              title: AnimatedSearchBar(
                animationDuration: const Duration(seconds: 3330),
                controller: searchController,
                searchDecoration: const InputDecoration(
                  hintText: "Search here...",
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  debugPrint("value on Change");
                  setState(() {
                    handleSearchButtonTap();
                  });
                },
              ),
              actions: const [
                Row(
                  children: [
                    Icon(CupertinoIcons.bell),
                    SizedBox(width: 15),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
              cat = (_cat[index] == "All") ? "" : _cat[index];
              productQueryParams = {
                'category': cat,
              };
              _fetchProducts(context.read<ProductCubit>());
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
    "All",
    "Tops",
    "Bottoms",
    "Dresses",
    "Hoodies & Sweats",
    "Accessories",
  ];
}

enum User { student, instructor, admin }
