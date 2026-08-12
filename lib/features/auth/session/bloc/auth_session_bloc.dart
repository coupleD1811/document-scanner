import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/auth_failure.dart';
import '../../repository/auth_repository.dart';
import '../../repository/auth_user.dart';

part 'auth_session_event.dart';
part 'auth_session_state.dart';

class AuthSessionBloc extends Bloc<AuthSessionEvent, AuthSessionState> {
  AuthSessionBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthSessionState()) {
    on<AuthSessionSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthSessionSignOutRequested>(_onSignOutRequested);
  }

  final AuthRepository _authRepository;

  Future<void> _onSubscriptionRequested(
    AuthSessionSubscriptionRequested event,
    Emitter<AuthSessionState> emit,
  ) {
    return emit.onEach<AuthUser?>(
      _authRepository.user,
      onData: (user) {
        emit(
          state.copyWith(
            status: user == null
                ? AuthSessionStatus.unauthenticated
                : AuthSessionStatus.authenticated,
            submissionStatus: AuthSessionSubmissionStatus.idle,
            user: user,
            failureCode: null,
          ),
        );
      },
      onError: (_, _) {
        emit(
          state.copyWith(
            status: AuthSessionStatus.unauthenticated,
            submissionStatus: AuthSessionSubmissionStatus.failure,
            user: null,
            failureCode: AuthFailureCode.sessionRestoreFailed,
          ),
        );
      },
    );
  }

  Future<void> _onSignOutRequested(
    AuthSessionSignOutRequested event,
    Emitter<AuthSessionState> emit,
  ) async {
    emit(
      state.copyWith(
        submissionStatus: AuthSessionSubmissionStatus.inProgress,
        failureCode: null,
      ),
    );

    try {
      await _authRepository.signOut();
      emit(state.copyWith(submissionStatus: AuthSessionSubmissionStatus.idle));
    } on Object catch (error) {
      emit(
        state.copyWith(
          submissionStatus: AuthSessionSubmissionStatus.failure,
          failureCode: _failureCodeFor(
            error,
            fallback: AuthFailureCode.signOutFailed,
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
