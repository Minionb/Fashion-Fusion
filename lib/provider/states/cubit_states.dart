abstract class CubitState {}

class Initial extends CubitState {}

class DataLoading extends CubitState {}

class DataSuccess<T> extends CubitState {
  final T? data;

  DataSuccess({
    this.data,
  });
}

class DataFailure extends CubitState {
  final String errorMessage;

  DataFailure({
    required this.errorMessage,
  });
}
