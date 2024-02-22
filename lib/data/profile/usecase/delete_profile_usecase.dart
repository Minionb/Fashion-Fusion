import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../repository/profile_repository.dart';

class DeleteProfileUsecase {
  final ProfileRepository repository;
  DeleteProfileUsecase({required this.repository});
  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.delete(id);
  }
}
