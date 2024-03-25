import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/api/netwok_info.dart';
import 'package:fashion_fusion/data/auth/model/login_model.dart';
import 'package:fashion_fusion/data/auth/model/responed_model.dart';
import 'package:fashion_fusion/data/auth/model/signup_model.dart';
import 'package:fashion_fusion/data/auth/model/status_model.dart';
import 'package:fashion_fusion/error/exceptions.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../datasource/auth_remote_datasource.dart';

abstract class AuthRepository {
  Future<Either<Failure, ResponseModel>> login(LoginModel model);
  Future<Either<Failure, Status>> regiter(RegisterUserModel model);
  Future<Either<Failure, Status>> forgetPassword(String email);
  Future<Either<Failure, Unit>> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource remoteDatasource;
  AuthRepositoryImpl(
      {required this.networkInfo, required this.remoteDatasource});

  @override
  Future<Either<Failure, ResponseModel>> login(LoginModel model) async {
    if (await networkInfo.isConnected) {
      try {
        final reposnse = await remoteDatasource.login(model);
        return Right(reposnse);
      } on ServerException catch (e) {
        return Left(MyException(e.message ?? ""));
      }
    } else {}
    throw const ServerException();
  }

  @override
  Future<Either<Failure, Status>> regiter(RegisterUserModel model) async {
    if (await networkInfo.isConnected) {
      try {
        final reposnse = await remoteDatasource.register(model);
        return Right(reposnse);
      } on ServerException catch (e) {
        return Left(MyException(e.message ?? ""));
      }
    }
    throw const ServerException();
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    return await _getMessage(() {
      return remoteDatasource.logout();
    });
  }

  @override
  Future<Either<Failure, Status>> forgetPassword(String email) async {
    if (await networkInfo.isConnected) {
      try {
        final reposnse = await remoteDatasource.forgetPassword(email);
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
