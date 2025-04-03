part of 'user_edit_bloc.dart';

abstract class UserEditState extends Equatable {
  const UserEditState();

  @override
  List<Object> get props => [];
}

class UserEditInitial extends UserEditState {}

class UserEditLoading extends UserEditState {}

class UserEditSuccess extends UserEditState {}

class UserEditFailure extends UserEditState {
  final String message;

  const UserEditFailure({required this.message});

  @override
  List<Object> get props => [message];
}
