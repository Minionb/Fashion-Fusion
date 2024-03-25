import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../model/status_model.dart';
import '../repository/auth_repository.dart';

class ResetPasswordUsecase {
  final AuthRepository repository;
  ResetPasswordUsecase({required this.repository});
  Future<Either<Failure, Status>> call(String email) async {
    return await repository.forgetPassword(email);
  }
}
