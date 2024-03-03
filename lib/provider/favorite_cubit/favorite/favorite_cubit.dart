import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/favorite/model/favorite_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/favorite/usecase/get_favorite_usecase.dart';
part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final GetFavoriteUsecase get;
  FavoriteCubit({required this.get}) : super(FavoriteInitial());

  void getFavorite() async {
    emit(FavoriteIsLoadingState());
    final response = await get();
    emit(response.fold(
        (l) => FavoriteErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) => FavoriteLoadedState(models: r)));
  }
}
