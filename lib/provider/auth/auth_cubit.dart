import 'package:fashion_fusion/data/auth/model/login_model.dart';
import 'package:fashion_fusion/data/auth/model/signup_model.dart';
import 'package:fashion_fusion/data/auth/usecase/login_usecase.dart';
import 'package:fashion_fusion/data/auth/usecase/register_usecase.dart';
import 'package:fashion_fusion/provider/states/cubit_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<CubitState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  AuthCubit({required this.registerUsecase, required this.loginUsecase})
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
}
