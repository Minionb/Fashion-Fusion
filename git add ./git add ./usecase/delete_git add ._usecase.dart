import 'package:dartz/dartz.dart';
import '../repository/git add ._repository.dart';
import '../../../core/error/failures.dart';
class DeletegitAddUsecase {
  final gitAddRepository repository;
  DeletegitAddUsecase({required this.repository});
  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.delete(id);
  }
}
