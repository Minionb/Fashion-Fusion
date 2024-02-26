import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../repository/favorite_repository.dart';
import '../model/favorite_model.dart';


class GetFavoriteUsecase {
  final FavoriteRepository repository;
  GetFavoriteUsecase({required this.repository});
  Future<Either<Failure, FavoriteModel>> call() async {
    return await repository.get();
  }
}
