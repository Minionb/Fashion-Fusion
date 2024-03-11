import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../repository/product_repository.dart';
import '../model/product_model.dart';


class GetProductUsecase {
  final ProductRepository repository;
  
  GetProductUsecase({required this.repository});
  Future<Either<Failure, List<ProductModel>>> call(category, productName) async {
    return await repository.get(category, productName);
  }
}
