import '../../../l10n/l10n.dart';
import '../repository/auth_failure.dart';

extension AuthFailureMessage on AuthFailureCode {
  String localizedMessage(AppLocalizations l10n) {
    return switch (this) {
      AuthFailureCode.signInFailed => l10n.signInFailed,
      AuthFailureCode.accountCreationFailed => l10n.accountCreationFailed,
      AuthFailureCode.passwordResetFailed => l10n.passwordResetFailed,
      AuthFailureCode.signOutFailed => l10n.signOutFailed,
      AuthFailureCode.invalidEmail => l10n.invalidEmail,
      AuthFailureCode.incorrectCredentials => l10n.incorrectCredentials,
      AuthFailureCode.emailAlreadyInUse => l10n.emailAlreadyInUse,
      AuthFailureCode.weakPassword => l10n.weakPassword,
      AuthFailureCode.userDisabled => l10n.userDisabled,
      AuthFailureCode.emailPasswordNotEnabled => l10n.emailPasswordNotEnabled,
      AuthFailureCode.tooManyRequests => l10n.tooManyRequests,
      AuthFailureCode.networkRequestFailed => l10n.networkRequestFailed,
      AuthFailureCode.authenticationFailed => l10n.authenticationFailed,
      AuthFailureCode.sessionRestoreFailed => l10n.sessionRestoreFailed,
    };
  }
}
