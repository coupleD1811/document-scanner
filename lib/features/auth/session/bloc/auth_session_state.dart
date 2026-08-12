part of 'auth_session_bloc.dart';

const _unset = Object();

enum AuthSessionStatus { unknown, authenticated, unauthenticated }

enum AuthSessionSubmissionStatus { idle, inProgress, success, failure }

class AuthSessionState extends Equatable {
  const AuthSessionState({
    this.status = AuthSessionStatus.unknown,
    this.submissionStatus = AuthSessionSubmissionStatus.idle,
    this.user,
    this.failureCode,
  });

  final AuthSessionStatus status;
  final AuthSessionSubmissionStatus submissionStatus;
  final AuthUser? user;
  final AuthFailureCode? failureCode;

  bool get isAuthenticated => status == AuthSessionStatus.authenticated;

  AuthSessionState copyWith({
    AuthSessionStatus? status,
    AuthSessionSubmissionStatus? submissionStatus,
    Object? user = _unset,
    Object? failureCode = _unset,
  }) {
    return AuthSessionState(
      status: status ?? this.status,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      user: identical(user, _unset) ? this.user : user as AuthUser?,
      failureCode: identical(failureCode, _unset)
          ? this.failureCode
          : failureCode as AuthFailureCode?,
    );
  }

  @override
  List<Object?> get props => [status, submissionStatus, user, failureCode];
}
