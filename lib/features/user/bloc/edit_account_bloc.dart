import 'package:belog/features/user/domain/usecases/change_email_usecase.dart';
import 'package:belog/features/user/domain/usecases/reset_password_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_account_event.dart';
part 'edit_account_state.dart';

class EditAccountBloc extends Bloc<EditAccountEvent, EditAccountState> {
  final ChangeEmailUseCase changeEmailUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  EditAccountBloc({
    required this.changeEmailUseCase,
    required this.resetPasswordUseCase,
  }) : super(EditAccountInitial()) {
    on<ChangeEmailEvent>(_onChangeEmail);
    on<ResetPasswordEvent>(_onResetPassword);
  }

  Future<void> _onChangeEmail(
    ChangeEmailEvent event,
    Emitter<EditAccountState> emit,
  ) async {
    emit(EditAccountLoading());
    final result = await changeEmailUseCase(event.newEmail);
    result.fold(
      (failure) => emit(EditAccountFailure(message: failure.message)),
      (_) => emit(EditAccountSuccess(message: 'Email changed successfully')),
    );
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<EditAccountState> emit,
  ) async {
    emit(EditAccountLoading());
    final result = await resetPasswordUseCase(event.newPassword);
    result.fold(
      (failure) => emit(EditAccountFailure(message: failure.message)),
      (_) => emit(EditAccountSuccess(message: 'Password reset successfully')),
    );
  }
}
