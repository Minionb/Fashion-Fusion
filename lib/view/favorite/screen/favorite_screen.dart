import 'package:fashion_fusion/core/utils/app_images.dart';
import 'package:fashion_fusion/provider/favorite_cubit/favorite/favorite_cubit.dart';
import 'package:fashion_fusion/view/home/screen/home_screen.dart';
import 'package:fashion_fusion/view/home/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite"),
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteIsLoadingState) {}
          if (state is FavoriteLoadedState) {
            final model = state.models;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<FavoriteCubit>().getFavorite();
              },
              child: GridView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20).w,
                itemCount: model.model?.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20.sp,
                    crossAxisSpacing: 20.sp,
                    childAspectRatio: 0.72),
                itemBuilder: (context, index) {
                  final dat = model.model?[index];
                  return ProductCard(
                      isFav: true,
                      model: ProductModel(
                          id: dat?.productId ?? "",
                          label: dat?.productName ?? "",
                          imagePath: "${AppImages.imagePath}/10.jpeg",
                          price: dat?.price ?? 0));
                },
              ),
            );
          }
          if (state is FavoriteErrorState) {}
          return const SizedBox();
        },
      ),
    );
  }
}
