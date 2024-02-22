import 'package:dartz/dartz.dart';
import '../repository/product_repository.dart';
import '../model/upload_product_model.dart';
import '../../../core/error/failures.dart';
class AddProductUsecase {
  final ProductRepository repository;
  AddProductUsecase({required this.repository});
  Future<Either<Failure, ResponseUploadProductModel>> call(UploadProductModel model) async {
    return await repository.add(model);
  }
}
