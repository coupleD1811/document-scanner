part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

final class LoginPasswordResetRequested extends LoginEvent {
  const LoginPasswordResetRequested({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}
