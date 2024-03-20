import 'package:dartz/dartz.dart';
import '../repository/git add ._repository.dart';
import '../../../core/error/failures.dart';
import '../model/git add ._model.dart';


class GetgitAddUsecase {
  final gitAddRepository repository;
  GetgitAddUsecase({required this.repository});
  Future<Either<Failure, gitAddModel>> call() async {
    return await repository.get();
  }
}
