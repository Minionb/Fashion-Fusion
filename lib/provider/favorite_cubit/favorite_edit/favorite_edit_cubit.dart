import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/favorite/model/put_favorite_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/favorite/usecase/delete_favorite_usecase.dart';
import '../../../data/favorite/usecase/put_favorite_usecase.dart';
part 'favorite_edit_state.dart';

class FavoriteEditCubit extends Cubit<FavoriteEditState> {
  final PutFavoriteUsecase put;
  final DeleteFavoriteUsecase delete; 
  FavoriteEditCubit(
      {required this.put, required this.delete})
      : super(FavoriteEditInitial());

  void putFavorite(PutDeleteFavoriteModel model) async {
    emit(FavoriteEditIsLoadingState());
    final response = await put(model);
    emit(response.fold(
        (l) => FavoriteEditErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) =>FavoriteEditSuccessState()));
  }

  void deleteFavorite(PutDeleteFavoriteModel model) async {
    emit(FavoriteEditIsLoadingState());
    final response = await delete(model);
    emit(response.fold(
        (l) => FavoriteEditErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) =>FavoriteEditSuccessState()));
  }
}
