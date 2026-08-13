// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Scanly';

  @override
  String get firebaseNotConfiguredTitle => 'Chưa cấu hình Firebase';

  @override
  String get firebaseNotConfiguredBody =>
      'Tạo Firebase project, bật đăng nhập Email/Mật khẩu, rồi chạy cấu hình FlutterFire cho app này.';

  @override
  String get startupErrorTitle => 'Lỗi khởi động';

  @override
  String get secureWorkspaceTagline => 'Không gian tài liệu bảo mật của bạn';

  @override
  String get loginWelcomeTitle => 'Chào mừng trở lại';

  @override
  String get loginTitle => 'Đăng nhập';

  @override
  String get loginSubtitle => 'Tiếp tục quản lý tài liệu của bạn trên Scanly.';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get passwordLabel => 'Mật khẩu';

  @override
  String get showPasswordTooltip => 'Hiện mật khẩu';

  @override
  String get hidePasswordTooltip => 'Ẩn mật khẩu';

  @override
  String get loginAction => 'Đăng nhập';

  @override
  String get forgotPasswordAction => 'Quên mật khẩu';

  @override
  String get createNewAccountAction => 'Tạo tài khoản mới';

  @override
  String get orDivider => 'hoặc';

  @override
  String get continueWithGoogle => 'Tiếp tục với Google';

  @override
  String get continueWithFacebook => 'Tiếp tục với Facebook';

  @override
  String get socialLoginComingSoon =>
      'Đăng nhập mạng xã hội sẽ được bổ sung sau.';

  @override
  String get dontHaveAccountPrompt => 'Chưa có tài khoản?';

  @override
  String get alreadyHaveAccountPrompt => 'Đã có tài khoản?';

  @override
  String get authBackendNote =>
      'Xác thực dùng Firebase. API Node.js có thể kiểm tra Firebase ID token trong từng request.';

  @override
  String get registerTitle => 'Đăng ký';

  @override
  String get createAccountTitle => 'Tạo tài khoản';

  @override
  String get registerSubtitle =>
      'Tham gia Scanly và đơn giản hóa quy trình tài liệu của bạn.';

  @override
  String get confirmPasswordLabel => 'Nhập lại mật khẩu';

  @override
  String get createAccountAction => 'Tạo tài khoản';

  @override
  String get emailRequired => 'Vui lòng nhập email.';

  @override
  String get emailInvalid => 'Vui lòng nhập email hợp lệ.';

  @override
  String get passwordRequired => 'Vui lòng nhập mật khẩu.';

  @override
  String get passwordMinLength => 'Mật khẩu cần ít nhất 6 ký tự.';

  @override
  String get confirmPasswordRequired => 'Vui lòng nhập lại mật khẩu.';

  @override
  String get confirmPasswordMismatch => 'Mật khẩu nhập lại không khớp.';

  @override
  String get signInSuccess => 'Đăng nhập thành công.';

  @override
  String get accountCreatedSuccess => 'Tạo tài khoản thành công.';

  @override
  String get passwordResetEmailSent => 'Đã gửi email đặt lại mật khẩu.';

  @override
  String get signInFailed => 'Đăng nhập thất bại. Vui lòng thử lại.';

  @override
  String get accountCreationFailed =>
      'Tạo tài khoản thất bại. Vui lòng thử lại.';

  @override
  String get passwordResetFailed =>
      'Không gửi được email đặt lại mật khẩu. Vui lòng thử lại.';

  @override
  String get signOutFailed => 'Đăng xuất thất bại. Vui lòng thử lại.';

  @override
  String get invalidEmail => 'Vui lòng nhập email hợp lệ.';

  @override
  String get incorrectCredentials => 'Email hoặc mật khẩu không đúng.';

  @override
  String get emailAlreadyInUse => 'Email này đã được dùng để tạo tài khoản.';

  @override
  String get weakPassword => 'Dùng mật khẩu mạnh hơn với ít nhất 6 ký tự.';

  @override
  String get userDisabled => 'Tài khoản này đã bị vô hiệu hóa.';

  @override
  String get emailPasswordNotEnabled =>
      'Chưa bật đăng nhập Email/Mật khẩu trong Firebase.';

  @override
  String get tooManyRequests =>
      'Bạn đã thử quá nhiều lần. Chờ một chút rồi thử lại.';

  @override
  String get networkRequestFailed => 'Lỗi mạng. Kiểm tra kết nối rồi thử lại.';

  @override
  String get authenticationFailed => 'Xác thực thất bại.';

  @override
  String get sessionRestoreFailed => 'Không thể khôi phục phiên đăng nhập.';

  @override
  String get tabHome => 'Trang chủ';

  @override
  String get tabDocuments => 'Tài liệu';

  @override
  String get tabScan => 'Quét';

  @override
  String get tabTools => 'Công cụ';

  @override
  String get tabProfile => 'Cá nhân';

  @override
  String get signOutTooltip => 'Đăng xuất';

  @override
  String get readyToScanTitle => 'Sẵn sàng quét tài liệu';

  @override
  String get authenticatedAccountFallback => 'Tài khoản đã đăng nhập';

  @override
  String get scanlyProTitle => 'Scanly Pro';

  @override
  String get scanlyProSubtitle =>
      'Nâng cấp tài khoản để mở thêm OCR, cloud sync và xử lý PDF nâng cao.';

  @override
  String get nextFeaturesTitle => 'Tính năng tiếp theo';

  @override
  String get documentScannerTitle => 'Quét tài liệu';

  @override
  String get documentScannerSubtitle =>
      'Chụp, nhận diện mép giấy, cắt, làm rõ và xuất PDF.';

  @override
  String get nextStatus => 'Tiếp theo';

  @override
  String get pdfToolkitTitle => 'Bộ công cụ PDF';

  @override
  String get pdfToolkitSubtitle =>
      'Gộp, tách, sắp xếp, nén, đặt mật khẩu và ký.';

  @override
  String get plannedStatus => 'Dự kiến';

  @override
  String get ocrSearchTitle => 'Tìm kiếm OCR';

  @override
  String get ocrSearchSubtitle =>
      'Trích xuất chữ và tìm kiếm trong nội dung tài liệu.';

  @override
  String get documentsEmptyTitle => 'Chưa có tài liệu';

  @override
  String get documentsEmptySubtitle =>
      'Các file scan và PDF đã lưu sẽ xuất hiện ở đây.';

  @override
  String get scanPageTitle => 'Quét tài liệu mới';

  @override
  String get scanPageSubtitle =>
      'Mở camera để nhận diện mép giấy, cắt góc, làm rõ chữ và xuất PDF.';

  @override
  String get startScanAction => 'Bắt đầu quét';

  @override
  String get toolsPageSubtitle =>
      'Các công cụ xử lý PDF sẽ được gom ở đây để thao tác nhanh.';

  @override
  String get profileAccountTitle => 'Tài khoản';

  @override
  String get profileSettingsTitle => 'Cài đặt';

  @override
  String get languageSettingTitle => 'Ngôn ngữ';

  @override
  String get languageSettingSubtitle => 'Chọn ngôn ngữ hiển thị cho Scanly.';

  @override
  String get languagePickerTitle => 'Chọn ngôn ngữ';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get languageEnglish => 'Tiếng Anh';

  @override
  String get languageJapanese => 'Tiếng Nhật';

  @override
  String get cloudSyncTitle => 'Đồng bộ cloud';

  @override
  String get cloudSyncSubtitle => 'Sẽ được bổ sung khi backend sẵn sàng.';

  @override
  String get signOutAction => 'Đăng xuất';
}
