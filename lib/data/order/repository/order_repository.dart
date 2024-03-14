import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/api/netwok_info.dart';
import 'package:fashion_fusion/error/exceptions.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../datasource/order_remote_datasource.dart';
import '../model/order_model.dart';

abstract class OrderRepository {
  Future<Either<Failure, OrderModel>> postOrderCheckout(OrderModel model);
}

class OrderRepositoryImpl implements OrderRepository {
  final NetworkInfo networkInfo;
  final OrderRemoteDataSource remoteDatasource;

  OrderRepositoryImpl(
      {required this.networkInfo, required this.remoteDatasource});
  
  @override
  Future<Either<Failure, OrderModel>> postOrderCheckout(OrderModel model) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDatasource.postOrderCheckout(model);
        return Right(response);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {}
    throw const ServerException();
  }
}
