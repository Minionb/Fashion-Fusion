import 'package:dartz/dartz.dart';
import '../repository/git add ._repository.dart';
import '../model/upload_git add ._model.dart';
import '../../../core/error/failures.dart';
class AddgitAddUsecase {
  final gitAddRepository repository;
  AddgitAddUsecase({required this.repository});
  Future<Either<Failure, ResponseUploadgitAddModel>> call(UploadgitAddModel model) async {
    return await repository.add(model);
  }
}
