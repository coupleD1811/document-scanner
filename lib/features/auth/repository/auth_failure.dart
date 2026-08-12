class AuthFailure implements Exception {
  const AuthFailure(this.code);

  final AuthFailureCode code;

  @override
  String toString() => code.name;
}

enum AuthFailureCode {
  signInFailed,
  accountCreationFailed,
  passwordResetFailed,
  signOutFailed,
  invalidEmail,
  incorrectCredentials,
  emailAlreadyInUse,
  weakPassword,
  userDisabled,
  emailPasswordNotEnabled,
  tooManyRequests,
  networkRequestFailed,
  authenticationFailed,
  sessionRestoreFailed,
}
