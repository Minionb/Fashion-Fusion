import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../repository/customer_repository.dart';
import '../model/customer_model.dart';


class GetCustomerByIdUsecase {
  final CustomerRepository repository;
  GetCustomerByIdUsecase({required this.repository});
  Future<Either<Failure, CustomerDataModel>> call(String customerId) async {
    return await repository.getCustomerById(customerId);
  }
}
