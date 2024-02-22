import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../repository/product_repository.dart';

class DeleteProductUsecase {
  final ProductRepository repository;
  DeleteProductUsecase({required this.repository});
  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.delete(id);
  }
}
