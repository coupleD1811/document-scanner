// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Scanly';

  @override
  String get firebaseNotConfiguredTitle => 'Firebase is not configured';

  @override
  String get firebaseNotConfiguredBody =>
      'Create a Firebase project, enable Email/Password sign-in, then run FlutterFire configuration for this app.';

  @override
  String get startupErrorTitle => 'Startup error';

  @override
  String get secureWorkspaceTagline => 'Your secure document workspace';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle => 'Continue managing your documents in Scanly.';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get showPasswordTooltip => 'Show password';

  @override
  String get hidePasswordTooltip => 'Hide password';

  @override
  String get loginAction => 'Sign in';

  @override
  String get forgotPasswordAction => 'Forgot password';

  @override
  String get createNewAccountAction => 'Create new account';

  @override
  String get authBackendNote =>
      'Authentication uses Firebase. The Node.js API can verify the Firebase ID token on each request.';

  @override
  String get registerTitle => 'Register';

  @override
  String get createAccountTitle => 'Create account';

  @override
  String get registerSubtitle =>
      'Create a Scanly account to start saving and managing documents.';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get createAccountAction => 'Create account';

  @override
  String get emailRequired => 'Please enter your email.';

  @override
  String get emailInvalid => 'Please enter a valid email.';

  @override
  String get passwordRequired => 'Please enter your password.';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters.';

  @override
  String get confirmPasswordRequired => 'Please confirm your password.';

  @override
  String get confirmPasswordMismatch => 'Passwords do not match.';

  @override
  String get signInSuccess => 'Signed in successfully.';

  @override
  String get accountCreatedSuccess => 'Account created successfully.';

  @override
  String get passwordResetEmailSent => 'Password reset email sent.';

  @override
  String get signInFailed => 'Sign in failed. Please try again.';

  @override
  String get accountCreationFailed =>
      'Account creation failed. Please try again.';

  @override
  String get passwordResetFailed =>
      'Could not send the password reset email. Please try again.';

  @override
  String get signOutFailed => 'Sign out failed. Please try again.';

  @override
  String get invalidEmail => 'Please enter a valid email.';

  @override
  String get incorrectCredentials => 'Email or password is incorrect.';

  @override
  String get emailAlreadyInUse => 'This email is already used for an account.';

  @override
  String get weakPassword =>
      'Use a stronger password with at least 6 characters.';

  @override
  String get userDisabled => 'This account has been disabled.';

  @override
  String get emailPasswordNotEnabled =>
      'Email/Password sign-in is not enabled in Firebase.';

  @override
  String get tooManyRequests =>
      'Too many attempts. Wait a moment and try again.';

  @override
  String get networkRequestFailed =>
      'Network error. Check your connection and try again.';

  @override
  String get authenticationFailed => 'Authentication failed.';

  @override
  String get sessionRestoreFailed => 'Could not restore your sign-in session.';

  @override
  String get tabHome => 'Home';

  @override
  String get tabDocuments => 'Documents';

  @override
  String get tabScan => 'Scan';

  @override
  String get tabTools => 'Tools';

  @override
  String get tabProfile => 'Profile';

  @override
  String get signOutTooltip => 'Sign out';

  @override
  String get readyToScanTitle => 'Ready to scan';

  @override
  String get authenticatedAccountFallback => 'Signed-in account';

  @override
  String get scanlyProTitle => 'Scanly Pro';

  @override
  String get scanlyProSubtitle =>
      'Upgrade your account to unlock OCR, cloud sync, and advanced PDF processing.';

  @override
  String get nextFeaturesTitle => 'Next features';

  @override
  String get documentScannerTitle => 'Document scanner';

  @override
  String get documentScannerSubtitle =>
      'Capture, detect paper edges, crop, enhance, and export PDF.';

  @override
  String get nextStatus => 'Next';

  @override
  String get pdfToolkitTitle => 'PDF toolkit';

  @override
  String get pdfToolkitSubtitle =>
      'Merge, split, reorder, compress, password-protect, and sign.';

  @override
  String get plannedStatus => 'Planned';

  @override
  String get ocrSearchTitle => 'OCR search';

  @override
  String get ocrSearchSubtitle =>
      'Extract text and search inside document content.';

  @override
  String get documentsEmptyTitle => 'No documents yet';

  @override
  String get documentsEmptySubtitle =>
      'Saved scans and PDF files will appear here.';

  @override
  String get scanPageTitle => 'Scan a new document';

  @override
  String get scanPageSubtitle =>
      'Open the camera to detect paper edges, correct perspective, enhance text, and export PDF.';

  @override
  String get startScanAction => 'Start scanning';

  @override
  String get toolsPageSubtitle =>
      'PDF tools will be grouped here for quick actions.';

  @override
  String get profileAccountTitle => 'Account';

  @override
  String get profileSettingsTitle => 'Settings';

  @override
  String get languageSettingTitle => 'Language';

  @override
  String get languageSettingSubtitle =>
      'Uses device language, with Vietnamese, English, and Japanese support.';

  @override
  String get cloudSyncTitle => 'Cloud sync';

  @override
  String get cloudSyncSubtitle => 'Coming after the backend is ready.';

  @override
  String get signOutAction => 'Sign out';
}
