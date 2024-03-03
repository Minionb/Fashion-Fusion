import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../repository/customer_repository.dart';

class DeleteCustomerUsecase {
  final CustomerRepository repository;
  DeleteCustomerUsecase({required this.repository});
  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.delete(id);
  }
}
