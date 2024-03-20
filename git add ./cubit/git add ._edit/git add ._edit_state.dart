part of 'git add ._edit_cubit.dart';

abstract class gitAddEditState extends Equatable {
  const gitAddEditState();

  @override
  List<Object> get props => [];
}

class gitAddEditInitial extends gitAddEditState {}

class gitAddEditIsLoadingState extends gitAddEditState {}

class gitAddEditSuccessState extends gitAddEditState {}

class gitAddEditErrorState extends gitAddEditState {
  final String message;

  const gitAddEditErrorState({required this.message});
}
