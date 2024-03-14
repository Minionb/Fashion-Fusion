import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/data/product/model/upload_product_model.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../repository/product_repository.dart';

class UpdateProductUsecase {
  final ProductRepository repository;
  UpdateProductUsecase({required this.repository});
  Future<Either<Failure, Unit>> call(UploadProductModel model,String id) async {
    return await repository.update(model,id);
  }
}
