import 'package:fashion_fusion/data/auth/model/login_model.dart';
import 'package:fashion_fusion/data/auth/model/set_password.dart';
import 'package:fashion_fusion/data/auth/model/signup_model.dart';
import 'package:fashion_fusion/data/auth/usecase/login_usecase.dart';
import 'package:fashion_fusion/data/auth/usecase/register_usecase.dart';
import 'package:fashion_fusion/data/auth/usecase/reset_password_usecase.dart';
import 'package:fashion_fusion/data/auth/usecase/set_password_usecase.dart';
import 'package:fashion_fusion/provider/states/cubit_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<CubitState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final ResetPasswordUsecase resetPasswordUsecase;
  final SetPasswordUsecase setPasswordUsecase;

  AuthCubit({required this.registerUsecase, required this.loginUsecase, required this.resetPasswordUsecase, required this.setPasswordUsecase})
      : super(Initial());

  void login(LoginModel model) async {
    emit(DataLoading());
    final response = await loginUsecase(model);
    emit(response.fold((l) => DataFailure(errorMessage: l.toString()),
        (r) => DataSuccess(data: r)));
  }

  void register(RegisterUserModel model) async {
    emit(DataLoading());
    final response = await registerUsecase(model);
    emit(response.fold((l) => DataFailure(errorMessage: l.toString()),
        (r) => DataSuccess(data: r)));
  }

  void resetPassword(String email) async {
    emit(DataLoading());
    final response = await resetPasswordUsecase(email);
    emit(response.fold((l) => DataFailure(errorMessage: l.toString()),
        (r) => DataSuccess(data: r)));
  }

  void setPassword(SetPasswordModel model) async {
    emit(DataLoading());
    final response = await setPasswordUsecase(model);
    emit(response.fold((l) => DataFailure(errorMessage: l.toString()),
        (r) => DataSuccess(data: r)));
  }
  
}
