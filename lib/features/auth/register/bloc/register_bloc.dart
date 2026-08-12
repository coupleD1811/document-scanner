import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/auth_failure.dart';
import '../../repository/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const RegisterState()) {
    on<RegisterSubmitted>(_onSubmitted);
  }

  final AuthRepository _authRepository;

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      state.copyWith(
        status: RegisterStatus.inProgress,
        failureCode: null,
        successMessage: null,
      ),
    );

    try {
      await _authRepository.signUpWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(
        state.copyWith(
          status: RegisterStatus.success,
          successMessage: RegisterSuccessMessage.accountCreated,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          failureCode: _failureCodeFor(
            error,
            fallback: AuthFailureCode.accountCreationFailed,
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
