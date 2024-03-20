import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/git add ./usecase/get_git add ._usecase.dart';
import '../../../core/utils/constant.dart';
part 'git add ._state.dart';

class gitAddCubit extends Cubit<gitAddState> {
    final GetgitAddUsecase get;
  gitAddCubit({required this.get}) : super(gitAddInitial());

    void getgitAdd() async {
    emit(gitAddIsLoadingState());
    final response = await get();
    emit(response.fold(
        (l) => gitAddErrorState(message: Constants.mapFailureToMsg(l)),
        (r) =>gitAddLoadedState(model: r)));
  }

}

// gitAdd::START
  sl.registerFactory(() => gitAddCubit(get: sl()));
  sl.registerFactory(
      () => gitAddEditCubit(add: sl(), update: sl(), delete: sl()));

  sl.registerLazySingleton<gitAddRepository>(() =>
      gitAddRepositoryImpl(networkInfo: sl(), remoteDatasource: sl()));


  sl.registerLazySingleton(() => GetgitAddUsecase(repository: sl()));
  sl.registerLazySingleton(() => AddgitAddUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeletegitAddUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdategitAddUsecase(repository: sl()));


  sl.registerLazySingleton<gitAddRemoteDataSource>(
      () => gitAddRemoteDataSourceImpl(apiConsumer: sl()));

// gitAdd::END