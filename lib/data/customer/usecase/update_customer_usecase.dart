import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/data/customer/model/upload_customer_model.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../repository/customer_repository.dart';


class UpdateCustomerUsecase {
  final CustomerRepository repository;
  UpdateCustomerUsecase({required this.repository});
  Future<Either<Failure, Unit>> call(UploadCustomerModel model) async {
    return await repository.update(model);
  }
}
