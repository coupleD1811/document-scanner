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
  String get loginWelcomeTitle => 'Welcome back';

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
  String get orDivider => 'or';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithFacebook => 'Continue with Facebook';

  @override
  String get socialLoginComingSoon => 'Social sign-in will be added later.';

  @override
  String get dontHaveAccountPrompt => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccountPrompt => 'Already have an account?';

  @override
  String get authBackendNote =>
      'Authentication uses Firebase. The Node.js API can verify the Firebase ID token on each request.';

  @override
  String get registerTitle => 'Register';

  @override
  String get createAccountTitle => 'Create account';

  @override
  String get registerSubtitle =>
      'Join Scanly and simplify your document workflow.';

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
  String get homeWelcomeGeneric => 'Welcome back';

  @override
  String get homeWorkspaceSubtitle => 'Your document workspace';

  @override
  String get homeScanDocumentAction => 'Scan document';

  @override
  String get homeScanDocumentSubtitle =>
      'Capture, crop, enhance, and export to PDF';

  @override
  String get homeQuickActionsTitle => 'Quick actions';

  @override
  String get quickImageToPdf => 'Image to PDF';

  @override
  String get quickImportPdf => 'Import PDF';

  @override
  String get quickOcr => 'OCR';

  @override
  String get quickCompressPdf => 'Compress PDF';

  @override
  String get quickSignDocument => 'Sign document';

  @override
  String get quickPasswordProtect => 'Password protect';

  @override
  String get homeRecentDocumentsTitle => 'Recent documents';

  @override
  String get viewAllAction => 'View all';

  @override
  String get homeNoRecentDocumentsTitle => 'No recent documents yet';

  @override
  String get homeNoRecentDocumentsSubtitle =>
      'Scan your first document to get started.';

  @override
  String get allToolsAction => 'All tools';

  @override
  String get mergePdfAction => 'Merge PDF';

  @override
  String get splitPdfAction => 'Split PDF';

  @override
  String get reorderPagesAction => 'Reorder pages';

  @override
  String get compressPdfAction => 'Compress PDF';

  @override
  String get homeScanlyProSubtitle =>
      'OCR, cloud sync, and unlimited PDF tools.';

  @override
  String get upgradeAction => 'Upgrade';

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
  String get searchDocumentsHint => 'Search documents';

  @override
  String get documentsFilterTitle => 'Filter documents';

  @override
  String get documentFilterAll => 'All';

  @override
  String get documentFilterScans => 'Scans';

  @override
  String get documentFilterPdfs => 'PDFs';

  @override
  String get clearSearchAction => 'Clear search';

  @override
  String get documentsComingNextTitle => 'Coming next';

  @override
  String get documentStorageTitle => 'Document storage';

  @override
  String get documentStorageSubtitle =>
      'Securely store and organize your files';

  @override
  String get searchDocumentsTitle => 'Search documents';

  @override
  String get searchDocumentsSubtitle => 'Find any file in seconds';

  @override
  String get ocrContentSearchTitle => 'OCR content search';

  @override
  String get ocrContentSearchSubtitle => 'Search text inside your documents';

  @override
  String get documentsCountLabel => 'documents';

  @override
  String get sortRecent => 'Recent';

  @override
  String get sortOldest => 'Oldest';

  @override
  String get ocrReadyLabel => 'OCR ready';

  @override
  String get openAction => 'Open';

  @override
  String get renameAction => 'Rename';

  @override
  String get shareAction => 'Share';

  @override
  String get moveAction => 'Move';

  @override
  String get deleteAction => 'Delete';

  @override
  String get documentsFeatureComingSoon =>
      'Document features will be added later.';

  @override
  String get noMatchingDocumentsTitle => 'No matching documents';

  @override
  String get noMatchingDocumentsSubtitle => 'Try another keyword or filter.';

  @override
  String get pageLabel => 'page';

  @override
  String get pagesLabel => 'pages';

  @override
  String get scanPageTitle => 'Scan a new document';

  @override
  String get scanPageSubtitle =>
      'Open the camera to detect paper edges, correct perspective, enhance text, and export PDF.';

  @override
  String get startScanAction => 'Start scanning';

  @override
  String get cameraPermissionRequesting => 'Checking camera access...';

  @override
  String get cameraInitializing => 'Starting the camera...';

  @override
  String get imageNormalizing => 'Preparing the captured image...';

  @override
  String get documentEdgesDetecting => 'Detecting document edges...';

  @override
  String get imageNormalizationFailureTitle => 'Unable to prepare this image';

  @override
  String get imageNormalizationFailureMessage =>
      'The captured image could not be read or normalized. Please capture it again.';

  @override
  String get cameraPermissionDeniedTitle => 'Scanly needs camera access';

  @override
  String get cameraPermissionDeniedMessage =>
      'Allow Scanly to use the camera to capture and scan documents.';

  @override
  String get cameraPermissionPermanentlyDeniedTitle =>
      'Camera access is turned off';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Open Settings and allow camera access for Scanly to continue scanning.';

  @override
  String get cameraRestrictedTitle => 'Camera access is restricted';

  @override
  String get cameraRestrictedMessage =>
      'Camera access is restricted on this device. Check system restrictions or contact the device administrator.';

  @override
  String get cameraUnavailableTitle => 'No camera found';

  @override
  String get cameraUnavailableMessage =>
      'This device has no available camera for document scanning.';

  @override
  String get cameraFailureTitle => 'Unable to open the camera';

  @override
  String get cameraFailureMessage =>
      'An error occurred while opening the camera. Please try again.';

  @override
  String get retryAction => 'Try again';

  @override
  String get openSettingsAction => 'Open Settings';

  @override
  String get captureDocumentTooltip => 'Capture document';

  @override
  String get scanCapturedMessage => 'Document image captured.';

  @override
  String get scanEditorTitle => 'Review scan';

  @override
  String scanEditorPageProgress(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String scanEditorPageNumber(int number) {
    return 'Page $number';
  }

  @override
  String get scanEditorAdd => 'Add';

  @override
  String get scanEditorAddPage => 'Add page';

  @override
  String get scanEditorDeletePage => 'Delete page';

  @override
  String get scanEditorReorderHint => 'Hold and drag to reorder';

  @override
  String get scanEditorCancel => 'Cancel';

  @override
  String get scanEditorContinue => 'Continue';

  @override
  String get scanEditorEmptyTitle => 'No scanned pages';

  @override
  String get scanEditorEmptySubtitle =>
      'Capture a page to continue this scan session.';

  @override
  String get scanEditorDiscardTitle => 'Discard this scan?';

  @override
  String get scanEditorDiscardMessage =>
      'All pages captured in this session will be removed.';

  @override
  String get scanEditorKeepEditing => 'Keep editing';

  @override
  String get scanEditorDiscard => 'Discard';

  @override
  String get documentEdgesDetected => 'Document edges detected';

  @override
  String get documentEdgesNotFound =>
      'Edges were not found. Adjust the corners manually.';

  @override
  String get documentEdgeDetectionFailed =>
      'Edge detection was unavailable. Adjust the corners manually.';

  @override
  String get documentCornersAdjusted => 'Document corners adjusted';

  @override
  String get scanAdjustCorners => 'Adjust';

  @override
  String get scanCornerEditorTitle => 'Adjust corners';

  @override
  String get scanCornerEditorHint =>
      'Drag each corner to match the document edges.';

  @override
  String get scanCornerInvalidMessage =>
      'Keep the four corners in order around the document.';

  @override
  String get scanCornerReset => 'Reset';

  @override
  String get scanCornerSave => 'Save corners';

  @override
  String get scanCornerTopLeft => 'Top-left corner';

  @override
  String get scanCornerTopRight => 'Top-right corner';

  @override
  String get scanCornerBottomRight => 'Bottom-right corner';

  @override
  String get scanCornerBottomLeft => 'Bottom-left corner';

  @override
  String get scanPdfComingSoon =>
      'PDF creation will be added in the next step.';

  @override
  String pdfSelectedMessage(String name) {
    return 'Selected $name.';
  }

  @override
  String get pdfImportFailed =>
      'Unable to open the PDF file. Please try again.';

  @override
  String get toolsPageTitle => 'PDF Tools';

  @override
  String get toolsPageSubtitle => 'Edit, convert and protect your documents';

  @override
  String get toolsEditOrganizeTitle => 'Edit & organize';

  @override
  String get toolsConvertExtractTitle => 'Convert & extract';

  @override
  String get toolsOptimizeTitle => 'Optimize';

  @override
  String get toolsSecurityTitle => 'Security';

  @override
  String get deletePagesAction => 'Delete pages';

  @override
  String get ocrTextAction => 'OCR text';

  @override
  String get toolsFeatureComingSoon =>
      'This tool will be available in a future version.';

  @override
  String get profileAccountTitle => 'Account';

  @override
  String get profileSettingsTitle => 'Settings';

  @override
  String get profileFreePlan => 'Free plan';

  @override
  String get profileUpgradeToPro => 'Upgrade to Scanly Pro';

  @override
  String get profileAppearanceTitle => 'Appearance';

  @override
  String get profileThemeSettingTitle => 'Display mode';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get profileLanguageSectionTitle => 'Language';

  @override
  String get profileAccountSecurityTitle => 'Account and security';

  @override
  String get profileAccountInformation => 'Account information';

  @override
  String get profileChangePassword => 'Change password';

  @override
  String get profilePrivacySecurity => 'Privacy and security';

  @override
  String get profileInformationSupportTitle => 'Information and support';

  @override
  String get profileTermsOfService => 'Terms of Service';

  @override
  String get profilePrivacyPolicy => 'Privacy Policy';

  @override
  String get profileAboutScanly => 'About Scanly';

  @override
  String get profileVersionValue => 'Version 1.0.0';

  @override
  String get profileFeatureComingSoon =>
      'This feature will be available in a future version.';

  @override
  String get languageSettingTitle => 'Language';

  @override
  String get languageSettingSubtitle =>
      'Choose the display language for Scanly.';

  @override
  String get languagePickerTitle => 'Choose language';

  @override
  String get languageVietnamese => 'Vietnamese';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageJapanese => 'Japanese';

  @override
  String get cloudSyncTitle => 'Cloud sync';

  @override
  String get cloudSyncSubtitle => 'Coming after the backend is ready.';

  @override
  String get signOutAction => 'Sign out';
}
