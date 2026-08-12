part of 'auth_session_bloc.dart';

sealed class AuthSessionEvent extends Equatable {
  const AuthSessionEvent();

  @override
  List<Object?> get props => [];
}

final class AuthSessionSubscriptionRequested extends AuthSessionEvent {
  const AuthSessionSubscriptionRequested();
}

final class AuthSessionSignOutRequested extends AuthSessionEvent {
  const AuthSessionSignOutRequested();
}
