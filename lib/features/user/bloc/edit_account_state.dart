part of 'edit_account_bloc.dart';

abstract class EditAccountState extends Equatable {
  const EditAccountState();

  @override
  List<Object?> get props => [];
}

class EditAccountInitial extends EditAccountState {}

class EditAccountLoading extends EditAccountState {}

class EditAccountSuccess extends EditAccountState {
  final String message;

  const EditAccountSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class EditAccountFailure extends EditAccountState {
  final String message;

  const EditAccountFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
