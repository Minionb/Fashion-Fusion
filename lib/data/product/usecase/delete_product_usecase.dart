import 'package:dartz/dartz.dart';
import '../repository/product_repository.dart';
import '../../../core/error/failures.dart';
class DeleteProductUsecase {
  final ProductRepository repository;
  DeleteProductUsecase({required this.repository});
  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.delete(id);
  }
}
