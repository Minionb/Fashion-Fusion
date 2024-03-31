import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../repository/customer_repository.dart';
import '../model/customer_model.dart';


class GetCustomerUsecase {
  final CustomerRepository repository;
  GetCustomerUsecase({required this.repository});
  Future<Either<Failure, List<CustomerDataModel>>> call(customerQueryParams) async {
    return await repository.getCustomers(customerQueryParams);
  }
}
