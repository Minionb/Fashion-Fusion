import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/api/netwok_info.dart';
import 'package:fashion_fusion/error/exceptions.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../datasource/customer_remote_datasource.dart';

import '../model/customer_model.dart';
import '../model/upload_customer_model.dart';


abstract class CustomerRepository {
  Future<Either<Failure, CustomerModel>> get();
  Future<Either<Failure, ResponseUploadCustomerModel>> add(UploadCustomerModel model);
  Future<Either<Failure, Unit>> update(UploadCustomerModel model);
  Future<Either<Failure, Unit>> delete(int id);
}

class CustomerRepositoryImpl implements CustomerRepository {
  final NetworkInfo networkInfo;
  final CustomerRemoteDataSource remoteDatasource;
  CustomerRepositoryImpl(
      {required this.networkInfo, required this.remoteDatasource}); 
  
  
  @override
  Future<Either<Failure, CustomerModel>> get() async {
    if (await networkInfo.isConnected) {
      try {
        final reposnse = await remoteDatasource.get();
        return Right(reposnse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {}
    throw const ServerException();
  }


  @override
  Future<Either<Failure, ResponseUploadCustomerModel>> add(UploadCustomerModel model) async {
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
  Future<Either<Failure, Unit>> delete(int id) async {
      return await _getMessage(() {
      return remoteDatasource.delete(id);
    });
  }



  @override
  Future<Either<Failure, Unit>> update(UploadCustomerModel model) async {
      if (await networkInfo.isConnected) {
      try {
        final reposnse = await remoteDatasource.update(model);
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
