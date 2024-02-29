import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/api/netwok_info.dart';
import 'package:fashion_fusion/data/favorite/model/put_favorite_model.dart';
import 'package:fashion_fusion/error/exceptions.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../datasource/favorite_remote_datasource.dart';
import '../model/favorite_model.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, FavoriteModel>> get();
  Future<Either<Failure, Unit>> delete(PutDeleteFavoriteModel model);
  Future<Either<Failure, Unit>> put(PutDeleteFavoriteModel model);
}

class FavoriteRepositoryImpl implements FavoriteRepository {
  final NetworkInfo networkInfo;
  final FavoriteRemoteDataSource remoteDatasource;
  FavoriteRepositoryImpl(
      {required this.networkInfo, required this.remoteDatasource});

  @override
  Future<Either<Failure, FavoriteModel>> get() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDatasource.get();
        return Right(response);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {}
    throw const ServerException();
  }

  @override
  Future<Either<Failure, Unit>> put(PutDeleteFavoriteModel model) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDatasource.put(model);
        return Right(response);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {}
    throw const ServerException();
  }

  @override
  Future<Either<Failure, Unit>> delete(PutDeleteFavoriteModel model) async {
    return await _getMessage(() {
      return remoteDatasource.delete(model);
    });
  }

  Future<Either<Failure, Unit>> _getMessage(
      DeleteOrUpdateOrAddRate deleteOrUpdateOrAddPost) async {
    if (await networkInfo.isConnected) {
      try {
        await deleteOrUpdateOrAddPost();
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

typedef DeleteOrUpdateOrAddRate = Future<Unit> Function();
