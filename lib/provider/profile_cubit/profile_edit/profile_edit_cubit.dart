import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/profile/model/upload_profile_model.dart';
import 'package:fashion_fusion/data/profile/usecase/add_profile_usecase.dart';
import 'package:fashion_fusion/data/profile/usecase/delete_profile_usecase.dart';
import 'package:fashion_fusion/data/profile/usecase/update_profile_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
//import '../../../../core/utils/constant.dart';
part 'profile_edit_state.dart';

class ProfileEditCubit extends Cubit<ProfileEditState> {
  final AddProfileUsecase add;
  final UpdateProfileUsecase update;
  final DeleteProfileUsecase delete;
  ProfileEditCubit(
      {required this.add, required this.update, required this.delete})
      : super(ProfileEditInitial());

  void addProfile(UploadProfileModel model) async {
    emit(ProfileEditIsLoadingState());
    final response = await add(model);
    emit(response.fold(
        (l) => ProfileEditErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) =>ProfileEditSuccessState()));
  }

  void updateProfile(UploadProfileModel model) async {
    emit(ProfileEditIsLoadingState());
    final response = await update(model);
    emit(response.fold(
        (l) => ProfileEditErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) =>ProfileEditSuccessState()));
  }

  void deleteProfile(int id) async {
    emit(ProfileEditIsLoadingState());
    final response = await delete(id);
    emit(response.fold(
        (l) => ProfileEditErrorState(message: HelperMethod.mapFailureToMsg(l)),
        (r) =>ProfileEditSuccessState()));
  }
}
