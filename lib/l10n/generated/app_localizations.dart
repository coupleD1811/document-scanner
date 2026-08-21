import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'Scanly'**
  String get appTitle;

  /// No description provided for @firebaseNotConfiguredTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa cấu hình Firebase'**
  String get firebaseNotConfiguredTitle;

  /// No description provided for @firebaseNotConfiguredBody.
  ///
  /// In vi, this message translates to:
  /// **'Tạo Firebase project, bật đăng nhập Email/Mật khẩu, rồi chạy cấu hình FlutterFire cho app này.'**
  String get firebaseNotConfiguredBody;

  /// No description provided for @startupErrorTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khởi động'**
  String get startupErrorTitle;

  /// No description provided for @secureWorkspaceTagline.
  ///
  /// In vi, this message translates to:
  /// **'Không gian tài liệu bảo mật của bạn'**
  String get secureWorkspaceTagline;

  /// No description provided for @loginWelcomeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng trở lại'**
  String get loginWelcomeTitle;

  /// No description provided for @loginTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục quản lý tài liệu của bạn trên Scanly.'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In vi, this message translates to:
  /// **'name@example.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get passwordLabel;

  /// No description provided for @showPasswordTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Hiện mật khẩu'**
  String get showPasswordTooltip;

  /// No description provided for @hidePasswordTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn mật khẩu'**
  String get hidePasswordTooltip;

  /// No description provided for @loginAction.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get loginAction;

  /// No description provided for @forgotPasswordAction.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu'**
  String get forgotPasswordAction;

  /// No description provided for @createNewAccountAction.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản mới'**
  String get createNewAccountAction;

  /// No description provided for @orDivider.
  ///
  /// In vi, this message translates to:
  /// **'hoặc'**
  String get orDivider;

  /// No description provided for @continueWithGoogle.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithFacebook.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với Facebook'**
  String get continueWithFacebook;

  /// No description provided for @socialLoginComingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập mạng xã hội sẽ được bổ sung sau.'**
  String get socialLoginComingSoon;

  /// No description provided for @dontHaveAccountPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài khoản?'**
  String get dontHaveAccountPrompt;

  /// No description provided for @alreadyHaveAccountPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản?'**
  String get alreadyHaveAccountPrompt;

  /// No description provided for @authBackendNote.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực dùng Firebase. API Node.js có thể kiểm tra Firebase ID token trong từng request.'**
  String get authBackendNote;

  /// No description provided for @registerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get registerTitle;

  /// No description provided for @createAccountTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get createAccountTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia Scanly và đơn giản hóa quy trình tài liệu của bạn.'**
  String get registerSubtitle;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lại mật khẩu'**
  String get confirmPasswordLabel;

  /// No description provided for @createAccountAction.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get createAccountAction;

  /// No description provided for @emailRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email.'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email hợp lệ.'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu.'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu cần ít nhất 6 ký tự.'**
  String get passwordMinLength;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập lại mật khẩu.'**
  String get confirmPasswordRequired;

  /// No description provided for @confirmPasswordMismatch.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu nhập lại không khớp.'**
  String get confirmPasswordMismatch;

  /// No description provided for @signInSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập thành công.'**
  String get signInSuccess;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản thành công.'**
  String get accountCreatedSuccess;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi email đặt lại mật khẩu.'**
  String get passwordResetEmailSent;

  /// No description provided for @signInFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập thất bại. Vui lòng thử lại.'**
  String get signInFailed;

  /// No description provided for @accountCreationFailed.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản thất bại. Vui lòng thử lại.'**
  String get accountCreationFailed;

  /// No description provided for @passwordResetFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không gửi được email đặt lại mật khẩu. Vui lòng thử lại.'**
  String get passwordResetFailed;

  /// No description provided for @signOutFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất thất bại. Vui lòng thử lại.'**
  String get signOutFailed;

  /// No description provided for @invalidEmail.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email hợp lệ.'**
  String get invalidEmail;

  /// No description provided for @incorrectCredentials.
  ///
  /// In vi, this message translates to:
  /// **'Email hoặc mật khẩu không đúng.'**
  String get incorrectCredentials;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In vi, this message translates to:
  /// **'Email này đã được dùng để tạo tài khoản.'**
  String get emailAlreadyInUse;

  /// No description provided for @weakPassword.
  ///
  /// In vi, this message translates to:
  /// **'Dùng mật khẩu mạnh hơn với ít nhất 6 ký tự.'**
  String get weakPassword;

  /// No description provided for @userDisabled.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản này đã bị vô hiệu hóa.'**
  String get userDisabled;

  /// No description provided for @emailPasswordNotEnabled.
  ///
  /// In vi, this message translates to:
  /// **'Chưa bật đăng nhập Email/Mật khẩu trong Firebase.'**
  String get emailPasswordNotEnabled;

  /// No description provided for @tooManyRequests.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã thử quá nhiều lần. Chờ một chút rồi thử lại.'**
  String get tooManyRequests;

  /// No description provided for @networkRequestFailed.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi mạng. Kiểm tra kết nối rồi thử lại.'**
  String get networkRequestFailed;

  /// No description provided for @authenticationFailed.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực thất bại.'**
  String get authenticationFailed;

  /// No description provided for @sessionRestoreFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể khôi phục phiên đăng nhập.'**
  String get sessionRestoreFailed;

  /// No description provided for @tabHome.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get tabHome;

  /// No description provided for @tabDocuments.
  ///
  /// In vi, this message translates to:
  /// **'Tài liệu'**
  String get tabDocuments;

  /// No description provided for @tabScan.
  ///
  /// In vi, this message translates to:
  /// **'Quét'**
  String get tabScan;

  /// No description provided for @tabTools.
  ///
  /// In vi, this message translates to:
  /// **'Công cụ'**
  String get tabTools;

  /// No description provided for @tabProfile.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân'**
  String get tabProfile;

  /// No description provided for @signOutTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get signOutTooltip;

  /// No description provided for @homeWelcomeGeneric.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng trở lại'**
  String get homeWelcomeGeneric;

  /// No description provided for @homeWorkspaceSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Không gian tài liệu của bạn'**
  String get homeWorkspaceSubtitle;

  /// No description provided for @homeScanDocumentAction.
  ///
  /// In vi, this message translates to:
  /// **'Quét tài liệu'**
  String get homeScanDocumentAction;

  /// No description provided for @homeScanDocumentSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chụp, cắt mép, làm rõ và xuất PDF'**
  String get homeScanDocumentSubtitle;

  /// No description provided for @homeQuickActionsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thao tác nhanh'**
  String get homeQuickActionsTitle;

  /// No description provided for @quickImageToPdf.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh sang PDF'**
  String get quickImageToPdf;

  /// No description provided for @quickImportPdf.
  ///
  /// In vi, this message translates to:
  /// **'Nhập PDF'**
  String get quickImportPdf;

  /// No description provided for @quickOcr.
  ///
  /// In vi, this message translates to:
  /// **'OCR'**
  String get quickOcr;

  /// No description provided for @quickCompressPdf.
  ///
  /// In vi, this message translates to:
  /// **'Nén PDF'**
  String get quickCompressPdf;

  /// No description provided for @quickSignDocument.
  ///
  /// In vi, this message translates to:
  /// **'Ký tài liệu'**
  String get quickSignDocument;

  /// No description provided for @quickPasswordProtect.
  ///
  /// In vi, this message translates to:
  /// **'Đặt mật khẩu'**
  String get quickPasswordProtect;

  /// No description provided for @homeRecentDocumentsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tài liệu gần đây'**
  String get homeRecentDocumentsTitle;

  /// No description provided for @viewAllAction.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get viewAllAction;

  /// No description provided for @homeNoRecentDocumentsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài liệu gần đây'**
  String get homeNoRecentDocumentsTitle;

  /// No description provided for @homeNoRecentDocumentsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Quét tài liệu đầu tiên để bắt đầu.'**
  String get homeNoRecentDocumentsSubtitle;

  /// No description provided for @allToolsAction.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get allToolsAction;

  /// No description provided for @mergePdfAction.
  ///
  /// In vi, this message translates to:
  /// **'Gộp PDF'**
  String get mergePdfAction;

  /// No description provided for @splitPdfAction.
  ///
  /// In vi, this message translates to:
  /// **'Tách PDF'**
  String get splitPdfAction;

  /// No description provided for @reorderPagesAction.
  ///
  /// In vi, this message translates to:
  /// **'Sắp xếp trang'**
  String get reorderPagesAction;

  /// No description provided for @compressPdfAction.
  ///
  /// In vi, this message translates to:
  /// **'Nén PDF'**
  String get compressPdfAction;

  /// No description provided for @homeScanlyProSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'OCR, cloud sync và công cụ PDF không giới hạn.'**
  String get homeScanlyProSubtitle;

  /// No description provided for @upgradeAction.
  ///
  /// In vi, this message translates to:
  /// **'Nâng cấp'**
  String get upgradeAction;

  /// No description provided for @readyToScanTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sẵn sàng quét tài liệu'**
  String get readyToScanTitle;

  /// No description provided for @authenticatedAccountFallback.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản đã đăng nhập'**
  String get authenticatedAccountFallback;

  /// No description provided for @scanlyProTitle.
  ///
  /// In vi, this message translates to:
  /// **'Scanly Pro'**
  String get scanlyProTitle;

  /// No description provided for @scanlyProSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nâng cấp tài khoản để mở thêm OCR, cloud sync và xử lý PDF nâng cao.'**
  String get scanlyProSubtitle;

  /// No description provided for @nextFeaturesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng tiếp theo'**
  String get nextFeaturesTitle;

  /// No description provided for @documentScannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quét tài liệu'**
  String get documentScannerTitle;

  /// No description provided for @documentScannerSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chụp, nhận diện mép giấy, cắt, làm rõ và xuất PDF.'**
  String get documentScannerSubtitle;

  /// No description provided for @nextStatus.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp theo'**
  String get nextStatus;

  /// No description provided for @pdfToolkitTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bộ công cụ PDF'**
  String get pdfToolkitTitle;

  /// No description provided for @pdfToolkitSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Gộp, tách, sắp xếp, nén, đặt mật khẩu và ký.'**
  String get pdfToolkitSubtitle;

  /// No description provided for @plannedStatus.
  ///
  /// In vi, this message translates to:
  /// **'Dự kiến'**
  String get plannedStatus;

  /// No description provided for @ocrSearchTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm OCR'**
  String get ocrSearchTitle;

  /// No description provided for @ocrSearchSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Trích xuất chữ và tìm kiếm trong nội dung tài liệu.'**
  String get ocrSearchSubtitle;

  /// No description provided for @documentsEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài liệu'**
  String get documentsEmptyTitle;

  /// No description provided for @documentsEmptySubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Các file scan và PDF đã lưu sẽ xuất hiện ở đây.'**
  String get documentsEmptySubtitle;

  /// No description provided for @searchDocumentsHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm tài liệu'**
  String get searchDocumentsHint;

  /// No description provided for @documentsFilterTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lọc tài liệu'**
  String get documentsFilterTitle;

  /// No description provided for @documentFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get documentFilterAll;

  /// No description provided for @documentFilterScans.
  ///
  /// In vi, this message translates to:
  /// **'Bản quét'**
  String get documentFilterScans;

  /// No description provided for @documentFilterPdfs.
  ///
  /// In vi, this message translates to:
  /// **'PDF'**
  String get documentFilterPdfs;

  /// No description provided for @clearSearchAction.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tìm kiếm'**
  String get clearSearchAction;

  /// No description provided for @documentsComingNextTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sắp ra mắt'**
  String get documentsComingNextTitle;

  /// No description provided for @documentStorageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ tài liệu'**
  String get documentStorageTitle;

  /// No description provided for @documentStorageSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ và sắp xếp tệp an toàn'**
  String get documentStorageSubtitle;

  /// No description provided for @searchDocumentsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm tài liệu'**
  String get searchDocumentsTitle;

  /// No description provided for @searchDocumentsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tìm mọi tệp trong vài giây'**
  String get searchDocumentsSubtitle;

  /// No description provided for @ocrContentSearchTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm nội dung OCR'**
  String get ocrContentSearchTitle;

  /// No description provided for @ocrContentSearchSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tìm chữ bên trong tài liệu của bạn'**
  String get ocrContentSearchSubtitle;

  /// No description provided for @documentsCountLabel.
  ///
  /// In vi, this message translates to:
  /// **'tài liệu'**
  String get documentsCountLabel;

  /// No description provided for @sortRecent.
  ///
  /// In vi, this message translates to:
  /// **'Gần đây'**
  String get sortRecent;

  /// No description provided for @sortOldest.
  ///
  /// In vi, this message translates to:
  /// **'Cũ nhất'**
  String get sortOldest;

  /// No description provided for @ocrReadyLabel.
  ///
  /// In vi, this message translates to:
  /// **'OCR sẵn sàng'**
  String get ocrReadyLabel;

  /// No description provided for @openAction.
  ///
  /// In vi, this message translates to:
  /// **'Mở'**
  String get openAction;

  /// No description provided for @renameAction.
  ///
  /// In vi, this message translates to:
  /// **'Đổi tên'**
  String get renameAction;

  /// No description provided for @shareAction.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ'**
  String get shareAction;

  /// No description provided for @moveAction.
  ///
  /// In vi, this message translates to:
  /// **'Di chuyển'**
  String get moveAction;

  /// No description provided for @deleteAction.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get deleteAction;

  /// No description provided for @documentsFeatureComingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng tài liệu sẽ được bổ sung sau.'**
  String get documentsFeatureComingSoon;

  /// No description provided for @noMatchingDocumentsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy tài liệu'**
  String get noMatchingDocumentsTitle;

  /// No description provided for @noMatchingDocumentsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Thử từ khóa hoặc bộ lọc khác.'**
  String get noMatchingDocumentsSubtitle;

  /// No description provided for @pageLabel.
  ///
  /// In vi, this message translates to:
  /// **'trang'**
  String get pageLabel;

  /// No description provided for @pagesLabel.
  ///
  /// In vi, this message translates to:
  /// **'trang'**
  String get pagesLabel;

  /// No description provided for @scanPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quét tài liệu mới'**
  String get scanPageTitle;

  /// No description provided for @scanPageSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Mở camera để nhận diện mép giấy, cắt góc, làm rõ chữ và xuất PDF.'**
  String get scanPageSubtitle;

  /// No description provided for @startScanAction.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu quét'**
  String get startScanAction;

  /// No description provided for @cameraPermissionRequesting.
  ///
  /// In vi, this message translates to:
  /// **'Đang kiểm tra quyền sử dụng camera...'**
  String get cameraPermissionRequesting;

  /// No description provided for @cameraInitializing.
  ///
  /// In vi, this message translates to:
  /// **'Đang khởi tạo camera...'**
  String get cameraInitializing;

  /// No description provided for @cameraPermissionDeniedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Scanly cần quyền camera'**
  String get cameraPermissionDeniedTitle;

  /// No description provided for @cameraPermissionDeniedMessage.
  ///
  /// In vi, this message translates to:
  /// **'Cho phép Scanly sử dụng camera để chụp và quét tài liệu.'**
  String get cameraPermissionDeniedMessage;

  /// No description provided for @cameraPermissionPermanentlyDeniedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quyền camera đang bị tắt'**
  String get cameraPermissionPermanentlyDeniedTitle;

  /// No description provided for @cameraPermissionPermanentlyDeniedMessage.
  ///
  /// In vi, this message translates to:
  /// **'Mở Cài đặt và cấp quyền camera cho Scanly để tiếp tục quét.'**
  String get cameraPermissionPermanentlyDeniedMessage;

  /// No description provided for @cameraRestrictedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không thể sử dụng camera'**
  String get cameraRestrictedTitle;

  /// No description provided for @cameraRestrictedMessage.
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị đang giới hạn quyền camera. Hãy kiểm tra giới hạn hệ thống hoặc liên hệ quản trị viên thiết bị.'**
  String get cameraRestrictedMessage;

  /// No description provided for @cameraUnavailableTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy camera'**
  String get cameraUnavailableTitle;

  /// No description provided for @cameraUnavailableMessage.
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị này không có camera khả dụng để quét tài liệu.'**
  String get cameraUnavailableMessage;

  /// No description provided for @cameraFailureTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không thể mở camera'**
  String get cameraFailureTitle;

  /// No description provided for @cameraFailureMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi khi mở camera. Hãy thử lại.'**
  String get cameraFailureMessage;

  /// No description provided for @retryAction.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retryAction;

  /// No description provided for @openSettingsAction.
  ///
  /// In vi, this message translates to:
  /// **'Mở Cài đặt'**
  String get openSettingsAction;

  /// No description provided for @captureDocumentTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Chụp tài liệu'**
  String get captureDocumentTooltip;

  /// No description provided for @scanCapturedMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã chụp ảnh tài liệu.'**
  String get scanCapturedMessage;

  /// No description provided for @pdfSelectedMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã chọn {name}.'**
  String pdfSelectedMessage(String name);

  /// No description provided for @pdfImportFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể mở tệp PDF. Hãy thử lại.'**
  String get pdfImportFailed;

  /// No description provided for @toolsPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Công cụ PDF'**
  String get toolsPageTitle;

  /// No description provided for @toolsPageSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa, chuyển đổi và bảo vệ tài liệu'**
  String get toolsPageSubtitle;

  /// No description provided for @toolsEditOrganizeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa và sắp xếp'**
  String get toolsEditOrganizeTitle;

  /// No description provided for @toolsConvertExtractTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển đổi và trích xuất'**
  String get toolsConvertExtractTitle;

  /// No description provided for @toolsOptimizeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tối ưu hóa'**
  String get toolsOptimizeTitle;

  /// No description provided for @toolsSecurityTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật'**
  String get toolsSecurityTitle;

  /// No description provided for @deletePagesAction.
  ///
  /// In vi, this message translates to:
  /// **'Xóa trang'**
  String get deletePagesAction;

  /// No description provided for @ocrTextAction.
  ///
  /// In vi, this message translates to:
  /// **'Văn bản OCR'**
  String get ocrTextAction;

  /// No description provided for @toolsFeatureComingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Công cụ này sẽ được bổ sung trong phiên bản tiếp theo.'**
  String get toolsFeatureComingSoon;

  /// No description provided for @profileAccountTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get profileAccountTitle;

  /// No description provided for @profileSettingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get profileSettingsTitle;

  /// No description provided for @profileFreePlan.
  ///
  /// In vi, this message translates to:
  /// **'Gói miễn phí'**
  String get profileFreePlan;

  /// No description provided for @profileUpgradeToPro.
  ///
  /// In vi, this message translates to:
  /// **'Nâng cấp lên Scanly Pro'**
  String get profileUpgradeToPro;

  /// No description provided for @profileAppearanceTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get profileAppearanceTitle;

  /// No description provided for @profileThemeSettingTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ hiển thị'**
  String get profileThemeSettingTitle;

  /// No description provided for @themeModeLight.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get themeModeDark;

  /// No description provided for @profileLanguageSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get profileLanguageSectionTitle;

  /// No description provided for @profileAccountSecurityTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản và bảo mật'**
  String get profileAccountSecurityTitle;

  /// No description provided for @profileAccountInformation.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin tài khoản'**
  String get profileAccountInformation;

  /// No description provided for @profileChangePassword.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu'**
  String get profileChangePassword;

  /// No description provided for @profilePrivacySecurity.
  ///
  /// In vi, this message translates to:
  /// **'Quyền riêng tư và bảo mật'**
  String get profilePrivacySecurity;

  /// No description provided for @profileInformationSupportTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin và hỗ trợ'**
  String get profileInformationSupportTitle;

  /// No description provided for @profileTermsOfService.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản dịch vụ'**
  String get profileTermsOfService;

  /// No description provided for @profilePrivacyPolicy.
  ///
  /// In vi, this message translates to:
  /// **'Chính sách quyền riêng tư'**
  String get profilePrivacyPolicy;

  /// No description provided for @profileAboutScanly.
  ///
  /// In vi, this message translates to:
  /// **'Về Scanly'**
  String get profileAboutScanly;

  /// No description provided for @profileVersionValue.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản 1.0.0'**
  String get profileVersionValue;

  /// No description provided for @profileFeatureComingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng này sẽ được bổ sung trong phiên bản tiếp theo.'**
  String get profileFeatureComingSoon;

  /// No description provided for @languageSettingTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get languageSettingTitle;

  /// No description provided for @languageSettingSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ hiển thị cho Scanly.'**
  String get languageSettingSubtitle;

  /// No description provided for @languagePickerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ'**
  String get languagePickerTitle;

  /// No description provided for @languageVietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get languageVietnamese;

  /// No description provided for @languageEnglish.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Anh'**
  String get languageEnglish;

  /// No description provided for @languageJapanese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Nhật'**
  String get languageJapanese;

  /// No description provided for @cloudSyncTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đồng bộ cloud'**
  String get cloudSyncTitle;

  /// No description provided for @cloudSyncSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Sẽ được bổ sung khi backend sẵn sàng.'**
  String get cloudSyncSubtitle;

  /// No description provided for @signOutAction.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get signOutAction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
