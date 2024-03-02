import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/api/netwok_info.dart';
import 'package:fashion_fusion/data/cart/model/delete_item_model.dart';
import 'package:fashion_fusion/data/cart/model/put_item_model.dart';
import 'package:fashion_fusion/error/exceptions.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../datasource/cart_remote_datasource.dart';
import '../model/cart_item_model.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItemModel>>> getCartItems();
  Future<Either<Failure, Unit>> deleteCartItems(DeleteCartItemModel model);
  Future<Either<Failure, Unit>> putCartItems(PutCartItemModel model);
}

class CartRepositoryImpl implements CartRepository {
  final NetworkInfo networkInfo;
  final CartRemoteDataSource remoteDatasource;
  CartRepositoryImpl(
      {required this.networkInfo, required this.remoteDatasource});

  @override
  Future<Either<Failure, List<CartItemModel>>> getCartItems() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDatasource.getCartItems();
        return Right(response);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {}
    throw const ServerException();
  }

  @override
  Future<Either<Failure, Unit>> putCartItems(PutCartItemModel model) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDatasource.putCartItems(model);
        return Right(response);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {}
    throw const ServerException();
  }

  @override
  Future<Either<Failure, Unit>> deleteCartItems(DeleteCartItemModel model) async {
    return await _getMessage(() {
      return remoteDatasource.deleteCartItems(model);
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
