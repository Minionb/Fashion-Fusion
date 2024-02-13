import 'package:dio/dio.dart';
import 'package:fashion_fusion/api/app_interceptors.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // sl.registerFactory(() => AuthCubit(
  //     loginUsecase: sl(), registerUsecase: sl(), logoutUsecase: sl()));

  // //! Repository
  // sl.registerLazySingleton<AuthRepository>(
  //     () => AuthRepositoryImpl(networkInfo: sl(), remoteDatasource: sl()));
  // //! Datasource
  // sl.registerLazySingleton<AuthRemoteDataSource>(
  //     () => AuthRemoteDataSourceImpl(apiConsumer: sl()));
  // //! Core
  // sl.registerLazySingleton<NetworkInfo>(
  //     () => NetworkInfoImpl(connectionChecker: sl()));
  // sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));
  // // ! Usecase
  // sl.registerLazySingleton<LoginUsecase>(() => LoginUsecase(repository: sl()));
  // sl.registerLazySingleton<LogoutUsecase>(
  //     () => LogoutUsecase(repository: sl()));
  // sl.registerLazySingleton<RegisterUsecase>(
  //     () => RegisterUsecase(repository: sl()));


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
