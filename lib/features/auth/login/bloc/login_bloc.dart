import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/auth_failure.dart';
import '../../repository/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const LoginState()) {
    on<LoginSubmitted>(_onSubmitted);
    on<LoginPasswordResetRequested>(_onPasswordResetRequested);
  }

  final AuthRepository _authRepository;

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.copyWith(
        status: LoginStatus.inProgress,
        failureCode: null,
        successMessage: null,
      ),
    );

    try {
      await _authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(
        state.copyWith(
          status: LoginStatus.success,
          successMessage: LoginSuccessMessage.signedIn,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          failureCode: _failureCodeFor(
            error,
            fallback: AuthFailureCode.signInFailed,
          ),
        ),
      );
    }
  }

  Future<void> _onPasswordResetRequested(
    LoginPasswordResetRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.copyWith(
        status: LoginStatus.inProgress,
        failureCode: null,
        successMessage: null,
      ),
    );

    try {
      await _authRepository.sendPasswordResetEmail(email: event.email);
      emit(
        state.copyWith(
          status: LoginStatus.success,
          successMessage: LoginSuccessMessage.passwordResetEmailSent,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          failureCode: _failureCodeFor(
            error,
            fallback: AuthFailureCode.passwordResetFailed,
          ),
        ),
      );
    }
  }
}

AuthFailureCode _failureCodeFor(
  Object error, {
  required AuthFailureCode fallback,
}) {
  if (error case AuthFailure(:final code)) {
    return code;
  }

  return fallback;
}
