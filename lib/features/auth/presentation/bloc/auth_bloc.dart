import 'dart:async';
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_log_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogIn _userLogIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc(
      {required UserSignUp userSignUp,
      required UserLogIn userLogIn,
      required CurrentUser currentUser,
      required AppUserCubit appUserCubit}) // because there is multiple usecase
      : _userSignUp = userSignUp,
        _userLogIn = userLogIn,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogIn);
    on<AuthIsUserLoggedIn>(_onAuthLoggedIn);
  }

  FutureOr<void> _onAuthLogIn(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _userLogIn(UserLogInParams(
      email: event.email,
      password: event.password,
    ));
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSucces(user, emit),
    );
  }

  FutureOr<void> _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _userSignUp(UserSignUpParams(
      email: event.email,
      name: event.name,
      password: event.password,
    ));
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSucces(user, emit),
    );
  }

  FutureOr<void> _onAuthLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSucces(user, emit),
    );
  }

  FutureOr<void> _emitAuthSucces(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
