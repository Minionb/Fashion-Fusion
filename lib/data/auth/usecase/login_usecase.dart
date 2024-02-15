import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/data/auth/model/login_model.dart';
import 'package:fashion_fusion/data/auth/model/responed_model.dart';
import 'package:fashion_fusion/data/auth/repository/auth_repository.dart';
import 'package:fashion_fusion/error/failures.dart';

class LoginUsecase {
  final AuthRepository repository;
  LoginUsecase({required this.repository});
  Future<Either<Failure, ResponseModel>> call(LoginModel model) async {
    return await repository.login(model);
  }
}
