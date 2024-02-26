part of 'favorite_cubit.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteIsLoadingState extends FavoriteState {}

class FavoriteLoadedState extends FavoriteState {
  final FavoriteModel model;
  
  const FavoriteLoadedState({required this.model});
}

class FavoriteErrorState extends FavoriteState {
  final String message;

  const FavoriteErrorState({required this.message});
}
