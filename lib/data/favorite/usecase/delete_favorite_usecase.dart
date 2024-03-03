import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/data/favorite/model/put_favorite_model.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../repository/favorite_repository.dart';

class DeleteFavoriteUsecase {
  final FavoriteRepository repository;
  DeleteFavoriteUsecase({required this.repository});
  Future<Either<Failure, Unit>> call(PutDeleteFavoriteModel model) async {
    return await repository.delete(model);
  }
}
