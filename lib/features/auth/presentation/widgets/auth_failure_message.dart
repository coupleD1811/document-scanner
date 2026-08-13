import '../../../../l10n/l10n.dart';
import '../../repository/auth_failure.dart';

extension AuthFailureMessage on AuthFailureCode {
  String localizedMessage(AppLocalizations t) {
    return switch (this) {
      AuthFailureCode.signInFailed => t.signInFailed,
      AuthFailureCode.accountCreationFailed => t.accountCreationFailed,
      AuthFailureCode.passwordResetFailed => t.passwordResetFailed,
      AuthFailureCode.signOutFailed => t.signOutFailed,
      AuthFailureCode.invalidEmail => t.invalidEmail,
      AuthFailureCode.incorrectCredentials => t.incorrectCredentials,
      AuthFailureCode.emailAlreadyInUse => t.emailAlreadyInUse,
      AuthFailureCode.weakPassword => t.weakPassword,
      AuthFailureCode.userDisabled => t.userDisabled,
      AuthFailureCode.emailPasswordNotEnabled => t.emailPasswordNotEnabled,
      AuthFailureCode.tooManyRequests => t.tooManyRequests,
      AuthFailureCode.networkRequestFailed => t.networkRequestFailed,
      AuthFailureCode.authenticationFailed => t.authenticationFailed,
      AuthFailureCode.sessionRestoreFailed => t.sessionRestoreFailed,
    };
  }
}
