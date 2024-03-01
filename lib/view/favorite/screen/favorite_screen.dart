import 'package:fashion_fusion/api/end_points.dart';
import 'package:fashion_fusion/core/utils/app_colors.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/core/widgets/like_button.dart';
import 'package:fashion_fusion/data/favorite/model/favorite_model.dart';
import 'package:fashion_fusion/provider/favorite_cubit/favorite/favorite_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewFavoritesScreen extends StatefulWidget {
  const ViewFavoritesScreen({super.key});

  @override
  State<ViewFavoritesScreen> createState() => _ViewFavoritesScreenState();
}

class _ViewFavoritesScreenState extends State<ViewFavoritesScreen> {
  late List<FavoriteModel> _favorites;

  Future<void> _fetchFavorites(FavoriteCubit favoriteCubit) async {
    setState(() {
      favoriteCubit.getFavorite();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchFavorites(context.read<FavoriteCubit>());
  }

  @override
  Widget build(BuildContext context) {
    return HelperMethod.loader(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Favorites'),
        ),
        body: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteIsLoadingState) {}
            if (state is FavoriteLoadedState) {
              _favorites = state.models
                  .where((favorite) => favorite.isFavorite ?? true)
                  .toList();
              return RefreshIndicator(
                  onRefresh: () async {
                    _fetchFavorites(context
                        .read<FavoriteCubit>()); // Trigger fetching favorites
                  },
                  child: _buildFavoriteList());
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
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
            favorite: favorite,
            onLikeStatusChanged: (isLiked) {
              favorite.isFavorite = isLiked;
              // Get updated list of favorite items from backend
              setState(() {
                _fetchFavorites(context
                    .read<FavoriteCubit>()); // Trigger fetching favorites
              });
            });
      },
    );
  }
}

class FavoriteListItem extends StatelessWidget {
  final FavoriteModel favorite;
  final Function(bool isLiked) onLikeStatusChanged; // Callback function
  final VoidCallback onAddToCardPressed; // Callback function for add button

  const FavoriteListItem({
    super.key,
    required this.favorite,
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
    var imageUrl =
        'https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png';
    if (favorite.imageId?.isNotEmpty ?? true) {
      imageUrl = EndPoints.getProductImagesByImageId
          .replaceAll(":imageId", favorite.imageId ?? '');
    }
    return ListTile(
      leading: Image.network(
        imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text(favorite.productName ?? 'Product Description'),
      subtitle: Text('\$${favorite.price ?? 0.toStringAsFixed(2)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.add_shopping_cart,
              color: AppColors.primary,
            ),
            onPressed: _defaultOnAddToCardPressed,
          ),
          const SizedBox(width: 10), // Add some spacing between the buttons
          LikeButton(
            isFavorite: favorite.isFavorite ?? true,
            productId: favorite.productId ?? '',
            onLikeStatusChanged: onLikeStatusChanged,
          ),
        ],
      ),
    );
  }
}
