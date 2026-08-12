part of 'register_bloc.dart';

const _unset = Object();

enum RegisterStatus { idle, inProgress, success, failure }

enum RegisterSuccessMessage { accountCreated }

class RegisterState extends Equatable {
  const RegisterState({
    this.status = RegisterStatus.idle,
    this.failureCode,
    this.successMessage,
  });

  final RegisterStatus status;
  final AuthFailureCode? failureCode;
  final RegisterSuccessMessage? successMessage;

  RegisterState copyWith({
    RegisterStatus? status,
    Object? failureCode = _unset,
    Object? successMessage = _unset,
  }) {
    return RegisterState(
      status: status ?? this.status,
      failureCode: identical(failureCode, _unset)
          ? this.failureCode
          : failureCode as AuthFailureCode?,
      successMessage: identical(successMessage, _unset)
          ? this.successMessage
          : successMessage as RegisterSuccessMessage?,
    );
  }

  @override
  List<Object?> get props => [status, failureCode, successMessage];
}
