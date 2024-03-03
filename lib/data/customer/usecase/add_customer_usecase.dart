import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../repository/customer_repository.dart';
import '../model/upload_customer_model.dart';

class AddCustomerUsecase {
  final CustomerRepository repository;
  AddCustomerUsecase({required this.repository});
  Future<Either<Failure, ResponseUploadCustomerModel>> call(UploadCustomerModel model) async {
    return await repository.add(model);
  }
}
