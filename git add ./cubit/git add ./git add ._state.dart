part of 'git add ._cubit.dart';

abstract class gitAddState extends Equatable {
  const gitAddState();

  @override
  List<Object> get props => [];
}

class gitAddInitial extends gitAddState {}

class gitAddIsLoadingState extends gitAddState {}

class gitAddLoadedState extends gitAddState {
  final gitAddModel model;
  
  const gitAddLoadedState({required this.model});
}

class gitAddErrorState extends gitAddState {
  final String message;

  const gitAddErrorState({required this.message});
}
