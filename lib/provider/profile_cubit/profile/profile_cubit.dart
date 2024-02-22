import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/data/profile/model/profile_model.dart';
import 'package:fashion_fusion/data/profile/usecase/get_profile_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';


part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUsecase get;
  ProfileCubit({required this.get}) : super(ProfileInitial());

  void getProfile(String userID) async {
    emit(ProfileIsLoadingState());
    final response = await get(userID);
    emit(response.fold(
        (l) => ProfileErrorState(errorMessage: HelperMethod.mapFailureToMsg(l)),
        (r) => ProfileLoadedState(model: r)));
  }

}

