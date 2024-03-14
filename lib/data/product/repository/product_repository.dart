import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/api/netwok_info.dart';
import 'package:fashion_fusion/error/exceptions.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../datasource/product_remote_datasource.dart';
import '../model/product_model.dart';
import '../model/upload_product_model.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> get(productQueryParams);
  Future<Either<Failure, ResponseUploadProductModel>> add(
      UploadProductModel model);
  Future<Either<Failure, Unit>> update(UploadProductModel model, String id);
  Future<Either<Failure, Unit>> delete(String id);
}

class ProductRepositoryImpl implements ProductRepository {
  final NetworkInfo networkInfo;
  final ProductRemoteDataSource remoteDatasource;
  ProductRepositoryImpl(
      {required this.networkInfo, required this.remoteDatasource});

  @override
  Future<Either<Failure, List<ProductModel>>> get(productQueryParams) async {
    if (await networkInfo.isConnected) {
      try {
        final reposnse = await remoteDatasource.get(productQueryParams);
        return Right(reposnse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {}
    throw const ServerException();
  }

  @override
  Future<Either<Failure, ResponseUploadProductModel>> add(
      UploadProductModel model) async {
    if (await networkInfo.isConnected) {
      try {
        final reposnse = await remoteDatasource.add(model);
        return Right(reposnse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {}
    throw const ServerException();
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    return await _getMessage(() {
      return remoteDatasource.delete(id);
    });
  }

  @override
  Future<Either<Failure, Unit>> update(
      UploadProductModel model, String id) async {
    if (await networkInfo.isConnected) {
      try {
        final reposnse = await remoteDatasource.update(model,id);
        return Right(reposnse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {}
    throw const ServerException();
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
