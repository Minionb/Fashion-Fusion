import 'package:fashion_fusion/api/end_points.dart';
import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/core/widgets/cart_button.dart';
import 'package:fashion_fusion/core/widgets/like_button.dart';
import 'package:fashion_fusion/data/favorite/model/favorite_model.dart';
import 'package:fashion_fusion/provider/favorite_cubit/favorite/favorite_cubit.dart';
import 'package:fashion_fusion/view/home/widget/app_bar.dart';
import 'package:fashion_fusion/view/home/widget/empty_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ViewFavoritesScreen extends StatefulWidget {
  const ViewFavoritesScreen({super.key});

  @override
  State<ViewFavoritesScreen> createState() => _ViewFavoritesScreenState();
}

class _ViewFavoritesScreenState extends State<ViewFavoritesScreen> {
  late List<FavoriteModel> _favorites;

  Future<void> _fetchFavorites() async {
    setState(() {
      context.read<FavoriteCubit>().getFavorite();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return HelperMethod.loader(
        child: Scaffold(
      body: SafeArea(
          bottom: false,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
              return <Widget>[
                const HomescreenAppBar(title: "Favorites"),
              ];
            },
            body: BlocBuilder<FavoriteCubit, FavoriteState>(
              builder: (context, state) {
                if (state is FavoriteIsLoadingState) {}
                if (state is FavoriteLoadedState) {
                  _favorites = state.models
                      .where((favorite) => favorite.isFavorite ?? true)
                      .toList();
                  return _buildFavoriteBody(context);
                } else {
                  return RefreshIndicator(
                      onRefresh: () async {
                        _fetchFavorites();
                      },
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ));
                }
              },
            ),
          )),
    ));
  }

  RefreshIndicator _buildFavoriteBody(BuildContext context) {
    var buildFavoriteList = _favorites.isNotEmpty
        ? _buildFavoriteList()
        : const EmptyListWidget(text: "No favorites yet");

    return RefreshIndicator(
      onRefresh: () async {
        _fetchFavorites();
      },
      child: AnimationLimiter(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0), // Add padding
            child: buildFavoriteList,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteList() {
    return ListView.builder(
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final favorite = _favorites[index];
        return FavoriteListItem(
            model: favorite,
            onLikeStatusChanged: (isLiked) {
              setState(() {
                favorite.isFavorite = isLiked;
              });
            });
      },
    );
  }
}

class FavoriteListItem extends StatelessWidget {
  final FavoriteModel model;
  final Function(bool isLiked) onLikeStatusChanged; // Callback function
  final VoidCallback onAddToCardPressed; // Callback function for add button

  const FavoriteListItem({
    super.key,
    required this.model,
    this.onAddToCardPressed = _defaultOnAddToCardPressed,
    this.onLikeStatusChanged = _defaultOnLikeStatusChanged,
  });

  // Default function for onLikeStatusChanged
  static void _defaultOnLikeStatusChanged(bool isLiked) {
    // No operation
  }
  // Default function for onLikeStatusChanged
  static void _defaultOnAddToCardPressed() {
    // No operation
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGray), // Add border
          borderRadius: BorderRadius.circular(8.0), // Add border radius
        ),
        margin: const EdgeInsets.only(bottom: 16.0), // Add margin
        child: ListTile(
          leading: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              _imageUrl(),
              width: 80,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _productName(),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _price(),
              Row(
                children: [
                  AddCartButton(
                    productId: model.productId,
                    isDark: false,
                  ),
                  const SizedBox(width: 16),
                  LikeButton(
                    isFavorite: model.isFavorite ?? true,
                    productId: model.productId,
                    onLikeStatusChanged: onLikeStatusChanged,
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  String _imageUrl() {
    var imageUrl =
        'https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png';
    if (model.imageId.isNotEmpty) {
      imageUrl = EndPoints.getProductImagesByImageId
          .replaceAll(":imageId", model.imageId);
    }
    return imageUrl;
  }

  Widget _price() {
    return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          "\$${model.price.toStringAsFixed(2)}",
          style: TextStyle(color: AppColors.textGray),
        ));
  }

  Widget _productName() {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Add padding
      child: Text(
        model.productName,
        maxLines: 2,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
