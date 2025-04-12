part of 'edit_account_bloc.dart';

abstract class EditAccountEvent extends Equatable {
  const EditAccountEvent();

  @override
  List<Object?> get props => [];
}

class ChangeEmailEvent extends EditAccountEvent {
  final String newEmail;

  const ChangeEmailEvent({required this.newEmail});

  @override
  List<Object?> get props => [newEmail];
}

class ResetPasswordEvent extends EditAccountEvent {
  final String newPassword;

  const ResetPasswordEvent({required this.newPassword});

  @override
  List<Object?> get props => [newPassword];
}
