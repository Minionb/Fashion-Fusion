part of 'profile_edit_cubit.dart';

abstract class ProfileEditState extends Equatable {
  const ProfileEditState();

  @override
  List<Object> get props => [];
}

class ProfileEditInitial extends ProfileEditState {}

class ProfileEditIsLoadingState extends ProfileEditState {}

class ProfileEditSuccessState extends ProfileEditState {}

class ProfileEditErrorState extends ProfileEditState {
  final String message;

  const ProfileEditErrorState({required this.message});
}
