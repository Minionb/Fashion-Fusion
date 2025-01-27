import 'package:dio/dio.dart';
import 'package:fashion_fusion/api/api_consumer.dart';
import 'package:fashion_fusion/api/app_interceptors.dart';
import 'package:fashion_fusion/api/dio_consumer.dart';
import 'package:fashion_fusion/api/netwok_info.dart';
import 'package:fashion_fusion/data/auth/datasource/auth_remote_datasource.dart';
import 'package:fashion_fusion/data/auth/repository/auth_repository.dart';
import 'package:fashion_fusion/data/auth/usecase/login_usecase.dart';
import 'package:fashion_fusion/data/auth/usecase/register_usecase.dart';
import 'package:fashion_fusion/data/auth/usecase/reset_password_usecase.dart';
import 'package:fashion_fusion/data/auth/usecase/set_password_usecase.dart';
import 'package:fashion_fusion/data/cart/datasource/cart_remote_datasource.dart';
import 'package:fashion_fusion/data/cart/repository/cart_repository.dart';
import 'package:fashion_fusion/data/customer/datasource/customer_remote_datasource.dart';
import 'package:fashion_fusion/data/customer/repository/customer_repository.dart';
import 'package:fashion_fusion/data/customer/usecase/add_customer_usecase.dart';
import 'package:fashion_fusion/data/customer/usecase/delete_customer_usecase.dart';
import 'package:fashion_fusion/data/customer/usecase/get_customer_by_id_usecase.dart';
import 'package:fashion_fusion/data/customer/usecase/get_customer_usecase.dart';
import 'package:fashion_fusion/data/customer/usecase/update_customer_usecase.dart';
import 'package:fashion_fusion/data/favorite/datasource/favorite_remote_datasource.dart';
import 'package:fashion_fusion/data/favorite/repository/favorite_repository.dart';
import 'package:fashion_fusion/data/favorite/usecase/delete_favorite_usecase.dart';
import 'package:fashion_fusion/data/favorite/usecase/get_favorite_usecase.dart';
import 'package:fashion_fusion/data/favorite/usecase/put_favorite_usecase.dart';
import 'package:fashion_fusion/data/order/datasource/order_remote_datasource.dart';
import 'package:fashion_fusion/data/order/repository/order_repository.dart';
import 'package:fashion_fusion/data/product/datasource/product_remote_datasource.dart';
import 'package:fashion_fusion/data/product/repository/product_repository.dart';
import 'package:fashion_fusion/data/product/usecase/add_product_usecase.dart';
import 'package:fashion_fusion/data/product/usecase/delete_product_usecase.dart';
import 'package:fashion_fusion/data/product/usecase/get_product_usecase.dart';
import 'package:fashion_fusion/data/product/usecase/update_product_usecase.dart';
import 'package:fashion_fusion/data/profile/datasource/profile_remote_datasource.dart';
import 'package:fashion_fusion/data/profile/repository/profile_repository.dart';
import 'package:fashion_fusion/data/profile/usecase/add_profile_usecase.dart';
import 'package:fashion_fusion/data/profile/usecase/delete_profile_usecase.dart';
import 'package:fashion_fusion/data/profile/usecase/get_profile_usecase.dart';
import 'package:fashion_fusion/data/profile/usecase/update_profile_usecase.dart';
import 'package:fashion_fusion/provider/auth/auth_cubit.dart';

import 'package:fashion_fusion/provider/customerCubit/customer/customer_cubit.dart';
import 'package:fashion_fusion/provider/customerCubit/customer_edit/customer_edit_cubit.dart';

import 'package:fashion_fusion/provider/cart_cubit/cart_cubit.dart';
import 'package:fashion_fusion/provider/favorite_cubit/favorite/favorite_cubit.dart';
import 'package:fashion_fusion/provider/favorite_cubit/favorite_edit/favorite_edit_cubit.dart';
import 'package:fashion_fusion/provider/order_cubit/order_cubit.dart';
import 'package:fashion_fusion/provider/order_edit_cubit/order_edit_cubit_cubit.dart';
import 'package:fashion_fusion/provider/product_cubit/product/product_cubit.dart';
import 'package:fashion_fusion/provider/product_cubit/product_edit/product_edit_cubit.dart';
import 'package:fashion_fusion/provider/profile_cubit/profile/profile_cubit.dart';
import 'package:fashion_fusion/provider/profile_cubit/profile_edit/profile_edit_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
      () => AuthCubit(registerUsecase: sl(), loginUsecase: sl(), resetPasswordUsecase: sl(), setPasswordUsecase: sl()));
  sl.registerFactory(() => OrderEditCubit(repository: sl()));
  // //! Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(networkInfo: sl(), remoteDatasource: sl()));
  // //! Datasource
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiConsumer: sl()));
  // //! Core
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: sl()));
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));
  // ! Usecase
  sl.registerLazySingleton<LoginUsecase>(() => LoginUsecase(repository: sl()));
  sl.registerLazySingleton<RegisterUsecase>(
      () => RegisterUsecase(repository: sl()));
  sl.registerLazySingleton<ResetPasswordUsecase>(
      () => ResetPasswordUsecase(repository: sl()));
  sl.registerLazySingleton<SetPasswordUsecase>(
      () => SetPasswordUsecase(repository: sl()));

// Product::START
  sl.registerFactory(() => ProductCubit(get: sl()));
  sl.registerFactory(
      () => ProductEditCubit(add: sl(), update: sl(), delete: sl()));

  sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(networkInfo: sl(), remoteDatasource: sl()));

  sl.registerLazySingleton(() => GetProductUsecase(repository: sl()));
  sl.registerLazySingleton(() => AddProductUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteProductUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateProductUsecase(repository: sl()));

  sl.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(apiConsumer: sl()));

// Product::END

// Favorite::START
  sl.registerFactory(() => FavoriteCubit(get: sl()));
  sl.registerFactory(() => FavoriteEditCubit(put: sl(), delete: sl()));

  sl.registerLazySingleton<FavoriteRepository>(
      () => FavoriteRepositoryImpl(networkInfo: sl(), remoteDatasource: sl()));

  sl.registerLazySingleton(() => GetFavoriteUsecase(repository: sl()));
  sl.registerLazySingleton(() => PutFavoriteUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteFavoriteUsecase(repository: sl()));

  sl.registerLazySingleton<FavoriteRemoteDataSource>(
      () => FavoriteRemoteDataSourceImpl(apiConsumer: sl()));

// Favorite::END

// Cart::START
  sl.registerFactory(() => CartCubit(repository: sl()));
  sl.registerFactory(() => OrderCubit(repository: sl()));

  sl.registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(networkInfo: sl(), remoteDatasource: sl()));
  sl.registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(apiConsumer: sl()));

  sl.registerLazySingleton<OrderRepository>(
      () => OrderRepositoryImpl(networkInfo: sl(), remoteDatasource: sl()));
  sl.registerLazySingleton<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(apiConsumer: sl()));

// Cart::END

  sl.registerFactory(() => ProfileCubit(get: sl()));

  sl.registerFactory(
      () => ProfileEditCubit(add: sl(), update: sl(), delete: sl()));

  sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(networkInfo: sl(), remoteDatasource: sl()));

  sl.registerLazySingleton(() => GetProfileUsecase(repository: sl()));
  sl.registerLazySingleton(() => AddProfileUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteProfileUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateProfileUsecase(repository: sl()));

  sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(apiConsumer: sl()));

// Customer::START
  sl.registerFactory(
      () => CustomerCubit(get: sl(), getCustomerByIdUsecase: sl()));
  sl.registerFactory(
      () => CustomerEditCubit(add: sl(), update: sl(), delete: sl()));

  sl.registerLazySingleton<CustomerRepository>(
      () => CustomerRepositoryImpl(networkInfo: sl(), remoteDatasource: sl()));

  sl.registerLazySingleton(() => GetCustomerUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetCustomerByIdUsecase(repository: sl()));
  sl.registerLazySingleton(() => AddCustomerUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteCustomerUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateCustomerUsecase(repository: sl()));

  sl.registerLazySingleton<CustomerRemoteDataSource>(
      () => CustomerRemoteDataSourceImpl(apiConsumer: sl()));

// Customer::END

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => AppIntercepters());
  sl.registerLazySingleton(() => LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      error: true));
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => Dio());
}
