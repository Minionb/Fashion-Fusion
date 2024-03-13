import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/api/netwok_info.dart';
import 'package:fashion_fusion/error/exceptions.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../datasource/profile_remote_datasource.dart';

import '../model/profile_model.dart';
import '../model/upload_profile_model.dart';


abstract class ProfileRepository {
  Future<Either<Failure, ProfileModel>> get(String userID);
  Future<Either<Failure, ResponseUploadProfileModel>> add(UploadProfileModel model);
  Future<Either<Failure, Unit>> update(UploadProfileModel model, String userID);
  Future<Either<Failure, Unit>> delete(int id);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final NetworkInfo networkInfo;
  final ProfileRemoteDataSource remoteDatasource;
  ProfileRepositoryImpl(
      {required this.networkInfo, required this.remoteDatasource}); 
  
  
  @override
  Future<Either<Failure, ProfileModel>> get(String userID) async {
    if (await networkInfo.isConnected) {
      try {
        final reposnse = await remoteDatasource.get(userID);
        return Right(reposnse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {}
    throw const ServerException();
  }


  @override
  Future<Either<Failure, ResponseUploadProfileModel>> add(UploadProfileModel model) async {
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
  Future<Either<Failure, Unit>> update(UploadProfileModel model, String userID) async {
      if (await networkInfo.isConnected) {
      try {
        final reposnse = await remoteDatasource.update(model, userID);
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
