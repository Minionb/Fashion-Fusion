import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/git add ./usecase/add_git add ._usecase.dart';
import '../../../data/git add ./usecase/delete_git add ._usecase.dart';
import '../../../data/git add ./usecase/update_git add ._usecase.dart';
import '../../../core/utils/constant.dart';
part 'git add ._edit_state.dart';

class gitAddEditCubit extends Cubit<gitAddEditState> {
  final AddgitAddUsecase add;
  final UpdategitAddUsecase update;
  final DeletegitAddUsecase delete;
  gitAddEditCubit(
      {required this.add, required this.update, required this.delete})
      : super(gitAddEditInitial());

  void addgitAdd(UploadgitAddModel model) async {
    emit(gitAddEditIsLoadingState());
    final response = await add(model);
    emit(response.fold(
        (l) => gitAddEditErrorState(message: Constants.mapFailureToMsg(l)),
        (r) =>gitAddEditSuccessState()));
  }

  void updategitAdd(UploadgitAddModel model) async {
    emit(gitAddEditIsLoadingState());
    final response = await update(model);
    emit(response.fold(
        (l) => gitAddEditErrorState(message: Constants.mapFailureToMsg(l)),
        (r) =>gitAddEditSuccessState()));
  }

  void deletegitAdd(int id) async {
    emit(gitAddEditIsLoadingState());
    final response = await delete(id);
    emit(response.fold(
        (l) => gitAddEditErrorState(message: Constants.mapFailureToMsg(l)),
        (r) =>gitAddEditSuccessState()));
  }
}
