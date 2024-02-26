part of 'favorite_edit_cubit.dart';

abstract class FavoriteEditState extends Equatable {
  const FavoriteEditState();

  @override
  List<Object> get props => [];
}

class FavoriteEditInitial extends FavoriteEditState {}

class FavoriteEditIsLoadingState extends FavoriteEditState {}

class FavoriteEditSuccessState extends FavoriteEditState {}

class FavoriteEditErrorState extends FavoriteEditState {
  final String message;

  const FavoriteEditErrorState({required this.message});
}
