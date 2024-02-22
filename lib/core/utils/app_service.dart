import 'package:dio/dio.dart';
import 'package:fashion_fusion/api/api_consumer.dart';
import 'package:fashion_fusion/api/app_interceptors.dart';
import 'package:fashion_fusion/api/dio_consumer.dart';
import 'package:fashion_fusion/api/netwok_info.dart';
import 'package:fashion_fusion/data/auth/datasource/auth_remote_datasource.dart';
import 'package:fashion_fusion/data/auth/repository/auth_repository.dart';
import 'package:fashion_fusion/data/auth/usecase/login_usecase.dart';
import 'package:fashion_fusion/data/auth/usecase/register_usecase.dart';
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
      () => AuthCubit(registerUsecase: sl(), loginUsecase: sl()));
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

// Product::START
  sl.registerFactory(() => ProductCubit(get: sl()));
  sl.registerFactory(
      () => ProductEditCubit(add: sl(), update: sl(), delete: sl()));

  sl.registerLazySingleton<ProductRepository>(() =>
      ProductRepositoryImpl(networkInfo: sl(), remoteDatasource: sl()));


  sl.registerLazySingleton(() => GetProductUsecase(repository: sl()));
  sl.registerLazySingleton(() => AddProductUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteProductUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateProductUsecase(repository: sl()));


  sl.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(apiConsumer: sl()));

// Product::END

  sl.registerFactory(
      () => ProfileCubit(get: sl()));

  sl.registerFactory(
      () => ProfileEditCubit(add: sl(), update: sl(), delete: sl()));

  sl.registerLazySingleton<ProfileRepository>(() =>
      ProfileRepositoryImpl(networkInfo: sl(), remoteDatasource: sl()));

  sl.registerLazySingleton(() => GetProfileUsecase(repository: sl()));
  sl.registerLazySingleton(() => AddProfileUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteProfileUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateProfileUsecase(repository: sl()));

  sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(apiConsumer: sl()));

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
