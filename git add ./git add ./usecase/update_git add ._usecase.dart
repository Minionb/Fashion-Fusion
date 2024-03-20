import 'package:dartz/dartz.dart';
import '../repository/git add ._repository.dart';
import '../../../core/error/failures.dart';

class UpdategitAddUsecase {
  final gitAddRepository repository;
  UpdategitAddUsecase({required this.repository});
  Future<Either<Failure, Unit>> call(UploadgitAddModel model) async {
    return await repository.update(model);
  }
}
