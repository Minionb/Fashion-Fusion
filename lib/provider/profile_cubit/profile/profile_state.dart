part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileIsLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final ProfileModel? model;
  
  const ProfileLoadedState({this.model});
}

class ProfileErrorState extends ProfileState {
  final String errorMessage;

  const ProfileErrorState({required this.errorMessage});
}
