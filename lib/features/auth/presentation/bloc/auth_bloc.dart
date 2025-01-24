import 'package:belog/features/auth/domain/usecases/user_login.dart';
import 'package:belog/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;

  AuthBloc({required UserSignUp userSignUp, required UserLogin userLogin})
      : _userSignUp = userSignUp,
        _userLogin = userLogin,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);

    on<AuthLogin>(_onAuthLogin);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter emit) async {
    emit(AuthLoading());

    final res = await _userSignUp(UserSignUpParams(
        email: event.email, name: event.name, password: event.password));

    res.fold((failure) => emit(AuthFailure(failure.message)),
        (user) => emit(AuthSuccess(user)));
  }

  void _onAuthLogin(AuthLogin event, Emitter emit) async {
    emit(AuthLoading());

    final res = await _userLogin(
        UserLoginParams(email: event.email, password: event.password));

    res.fold((failure) => emit(AuthFailure(failure.message)),
        (user) => emit(AuthSuccess(user)));
  }
}
