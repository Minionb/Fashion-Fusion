import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/data/auth/model/set_password.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../model/status_model.dart';
import '../repository/auth_repository.dart';

class SetPasswordUsecase {
  final AuthRepository repository;
  SetPasswordUsecase({required this.repository});
  Future<Either<Failure, Status>> call(SetPasswordModel setPasswordModel) async {
    return await repository.setPassword(setPasswordModel);
  }
}
