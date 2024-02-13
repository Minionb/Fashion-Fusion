import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/data/auth/model/signup_model.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../model/status_model.dart';
import '../repository/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repository;
  RegisterUsecase({required this.repository});
  Future<Either<Failure, Status>> call(RegisterUserModel model) async {
    return await repository.regiter(model);
  }
}
