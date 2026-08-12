part of 'login_bloc.dart';

const _unset = Object();

enum LoginStatus { idle, inProgress, success, failure }

enum LoginSuccessMessage { signedIn, passwordResetEmailSent }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.idle,
    this.failureCode,
    this.successMessage,
  });

  final LoginStatus status;
  final AuthFailureCode? failureCode;
  final LoginSuccessMessage? successMessage;

  LoginState copyWith({
    LoginStatus? status,
    Object? failureCode = _unset,
    Object? successMessage = _unset,
  }) {
    return LoginState(
      status: status ?? this.status,
      failureCode: identical(failureCode, _unset)
          ? this.failureCode
          : failureCode as AuthFailureCode?,
      successMessage: identical(successMessage, _unset)
          ? this.successMessage
          : successMessage as LoginSuccessMessage?,
    );
  }

  @override
  List<Object?> get props => [status, failureCode, successMessage];
}
