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
  String get homeWelcomeGeneric => 'Chào mừng trở lại';

  @override
  String get homeWorkspaceSubtitle => 'Không gian tài liệu của bạn';

  @override
  String get homeScanDocumentAction => 'Quét tài liệu';

  @override
  String get homeScanDocumentSubtitle => 'Chụp, cắt mép, làm rõ và xuất PDF';

  @override
  String get homeQuickActionsTitle => 'Thao tác nhanh';

  @override
  String get quickImageToPdf => 'Ảnh sang PDF';

  @override
  String get quickImportPdf => 'Nhập PDF';

  @override
  String get quickOcr => 'OCR';

  @override
  String get quickCompressPdf => 'Nén PDF';

  @override
  String get quickSignDocument => 'Ký tài liệu';

  @override
  String get quickPasswordProtect => 'Đặt mật khẩu';

  @override
  String get homeRecentDocumentsTitle => 'Tài liệu gần đây';

  @override
  String get viewAllAction => 'Xem tất cả';

  @override
  String get homeNoRecentDocumentsTitle => 'Chưa có tài liệu gần đây';

  @override
  String get homeNoRecentDocumentsSubtitle =>
      'Quét tài liệu đầu tiên để bắt đầu.';

  @override
  String get allToolsAction => 'Tất cả';

  @override
  String get mergePdfAction => 'Gộp PDF';

  @override
  String get splitPdfAction => 'Tách PDF';

  @override
  String get reorderPagesAction => 'Sắp xếp trang';

  @override
  String get compressPdfAction => 'Nén PDF';

  @override
  String get homeScanlyProSubtitle =>
      'OCR, cloud sync và công cụ PDF không giới hạn.';

  @override
  String get upgradeAction => 'Nâng cấp';

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
  String get searchDocumentsHint => 'Tìm kiếm tài liệu';

  @override
  String get documentsFilterTitle => 'Lọc tài liệu';

  @override
  String get documentFilterAll => 'Tất cả';

  @override
  String get documentFilterScans => 'Bản quét';

  @override
  String get documentFilterPdfs => 'PDF';

  @override
  String get clearSearchAction => 'Xóa tìm kiếm';

  @override
  String get documentsComingNextTitle => 'Sắp ra mắt';

  @override
  String get documentStorageTitle => 'Lưu trữ tài liệu';

  @override
  String get documentStorageSubtitle => 'Lưu trữ và sắp xếp tệp an toàn';

  @override
  String get searchDocumentsTitle => 'Tìm kiếm tài liệu';

  @override
  String get searchDocumentsSubtitle => 'Tìm mọi tệp trong vài giây';

  @override
  String get ocrContentSearchTitle => 'Tìm kiếm nội dung OCR';

  @override
  String get ocrContentSearchSubtitle => 'Tìm chữ bên trong tài liệu của bạn';

  @override
  String get documentsCountLabel => 'tài liệu';

  @override
  String get sortRecent => 'Gần đây';

  @override
  String get sortOldest => 'Cũ nhất';

  @override
  String get ocrReadyLabel => 'OCR sẵn sàng';

  @override
  String get openAction => 'Mở';

  @override
  String get renameAction => 'Đổi tên';

  @override
  String get shareAction => 'Chia sẻ';

  @override
  String get moveAction => 'Di chuyển';

  @override
  String get deleteAction => 'Xóa';

  @override
  String get documentsFeatureComingSoon =>
      'Tính năng tài liệu sẽ được bổ sung sau.';

  @override
  String get noMatchingDocumentsTitle => 'Không tìm thấy tài liệu';

  @override
  String get noMatchingDocumentsSubtitle => 'Thử từ khóa hoặc bộ lọc khác.';

  @override
  String get pageLabel => 'trang';

  @override
  String get pagesLabel => 'trang';

  @override
  String get scanPageTitle => 'Quét tài liệu mới';

  @override
  String get scanPageSubtitle =>
      'Mở camera để nhận diện mép giấy, cắt góc, làm rõ chữ và xuất PDF.';

  @override
  String get startScanAction => 'Bắt đầu quét';

  @override
  String get cameraPermissionRequesting =>
      'Đang kiểm tra quyền sử dụng camera...';

  @override
  String get cameraInitializing => 'Đang khởi tạo camera...';

  @override
  String get imageNormalizing => 'Đang chuẩn hóa ảnh vừa chụp...';

  @override
  String get documentEdgesDetecting => 'Đang nhận diện mép tài liệu...';

  @override
  String get imageNormalizationFailureTitle => 'Không thể chuẩn hóa ảnh';

  @override
  String get imageNormalizationFailureMessage =>
      'Scanly không thể đọc hoặc chuẩn hóa ảnh vừa chụp. Hãy chụp lại.';

  @override
  String get cameraPermissionDeniedTitle => 'Scanly cần quyền camera';

  @override
  String get cameraPermissionDeniedMessage =>
      'Cho phép Scanly sử dụng camera để chụp và quét tài liệu.';

  @override
  String get cameraPermissionPermanentlyDeniedTitle =>
      'Quyền camera đang bị tắt';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Mở Cài đặt và cấp quyền camera cho Scanly để tiếp tục quét.';

  @override
  String get cameraRestrictedTitle => 'Không thể sử dụng camera';

  @override
  String get cameraRestrictedMessage =>
      'Thiết bị đang giới hạn quyền camera. Hãy kiểm tra giới hạn hệ thống hoặc liên hệ quản trị viên thiết bị.';

  @override
  String get cameraUnavailableTitle => 'Không tìm thấy camera';

  @override
  String get cameraUnavailableMessage =>
      'Thiết bị này không có camera khả dụng để quét tài liệu.';

  @override
  String get cameraFailureTitle => 'Không thể mở camera';

  @override
  String get cameraFailureMessage =>
      'Đã xảy ra lỗi khi mở camera. Hãy thử lại.';

  @override
  String get retryAction => 'Thử lại';

  @override
  String get openSettingsAction => 'Mở Cài đặt';

  @override
  String get captureDocumentTooltip => 'Chụp tài liệu';

  @override
  String get scanCapturedMessage => 'Đã chụp ảnh tài liệu.';

  @override
  String get scanEditorTitle => 'Kiểm tra bản quét';

  @override
  String scanEditorPageProgress(int current, int total) {
    return 'Trang $current / $total';
  }

  @override
  String scanEditorPageNumber(int number) {
    return 'Trang $number';
  }

  @override
  String get scanEditorAdd => 'Thêm';

  @override
  String get scanEditorAddPage => 'Thêm trang';

  @override
  String get scanEditorDeletePage => 'Xóa trang';

  @override
  String get scanEditorReorderHint => 'Nhấn giữ và kéo để sắp xếp';

  @override
  String get scanEditorCancel => 'Hủy';

  @override
  String get scanEditorContinue => 'Tiếp tục';

  @override
  String get scanEditorEmptyTitle => 'Chưa có trang quét';

  @override
  String get scanEditorEmptySubtitle =>
      'Chụp một trang để tiếp tục phiên quét này.';

  @override
  String get scanEditorDiscardTitle => 'Hủy phiên quét?';

  @override
  String get scanEditorDiscardMessage =>
      'Tất cả trang đã chụp trong phiên này sẽ bị xóa.';

  @override
  String get scanEditorKeepEditing => 'Tiếp tục chỉnh sửa';

  @override
  String get scanEditorDiscard => 'Hủy phiên';

  @override
  String get documentEdgesDetected => 'Đã nhận diện mép tài liệu';

  @override
  String get documentEdgesNotFound =>
      'Không tìm thấy mép tài liệu. Hãy chỉnh các góc thủ công.';

  @override
  String get documentEdgeDetectionFailed =>
      'Không thể nhận diện mép. Hãy chỉnh các góc thủ công.';

  @override
  String get documentCornersAdjusted => 'Đã chỉnh các góc tài liệu';

  @override
  String get documentPerspectiveCorrecting => 'Đang cắt và chỉnh phối cảnh...';

  @override
  String get documentPerspectiveCorrected => 'Đã cắt và chỉnh phối cảnh';

  @override
  String get documentPerspectiveCorrectionFailed =>
      'Không thể xử lý trang này.';

  @override
  String get documentPerspectiveRetry => 'Thử xử lý lại';

  @override
  String get scanAdjustCorners => 'Chỉnh góc';

  @override
  String get scanCornerEditorTitle => 'Chỉnh các góc';

  @override
  String get scanCornerEditorHint => 'Kéo từng góc khớp với mép tài liệu.';

  @override
  String get scanCornerInvalidMessage =>
      'Giữ bốn góc theo đúng thứ tự quanh tài liệu.';

  @override
  String get scanCornerReset => 'Đặt lại';

  @override
  String get scanCornerSave => 'Lưu các góc';

  @override
  String get scanCornerTopLeft => 'Góc trên bên trái';

  @override
  String get scanCornerTopRight => 'Góc trên bên phải';

  @override
  String get scanCornerBottomRight => 'Góc dưới bên phải';

  @override
  String get scanCornerBottomLeft => 'Góc dưới bên trái';

  @override
  String get scanPdfComingSoon =>
      'Chức năng tạo PDF sẽ được bổ sung ở bước tiếp theo.';

  @override
  String pdfSelectedMessage(String name) {
    return 'Đã chọn $name.';
  }

  @override
  String get pdfImportFailed => 'Không thể mở tệp PDF. Hãy thử lại.';

  @override
  String get toolsPageTitle => 'Công cụ PDF';

  @override
  String get toolsPageSubtitle => 'Chỉnh sửa, chuyển đổi và bảo vệ tài liệu';

  @override
  String get toolsEditOrganizeTitle => 'Chỉnh sửa và sắp xếp';

  @override
  String get toolsConvertExtractTitle => 'Chuyển đổi và trích xuất';

  @override
  String get toolsOptimizeTitle => 'Tối ưu hóa';

  @override
  String get toolsSecurityTitle => 'Bảo mật';

  @override
  String get deletePagesAction => 'Xóa trang';

  @override
  String get ocrTextAction => 'Văn bản OCR';

  @override
  String get toolsFeatureComingSoon =>
      'Công cụ này sẽ được bổ sung trong phiên bản tiếp theo.';

  @override
  String get profileAccountTitle => 'Tài khoản';

  @override
  String get profileSettingsTitle => 'Cài đặt';

  @override
  String get profileFreePlan => 'Gói miễn phí';

  @override
  String get profileUpgradeToPro => 'Nâng cấp lên Scanly Pro';

  @override
  String get profileAppearanceTitle => 'Giao diện';

  @override
  String get profileThemeSettingTitle => 'Chế độ hiển thị';

  @override
  String get themeModeLight => 'Sáng';

  @override
  String get themeModeDark => 'Tối';

  @override
  String get profileLanguageSectionTitle => 'Ngôn ngữ';

  @override
  String get profileAccountSecurityTitle => 'Tài khoản và bảo mật';

  @override
  String get profileAccountInformation => 'Thông tin tài khoản';

  @override
  String get profileChangePassword => 'Đổi mật khẩu';

  @override
  String get profilePrivacySecurity => 'Quyền riêng tư và bảo mật';

  @override
  String get profileInformationSupportTitle => 'Thông tin và hỗ trợ';

  @override
  String get profileTermsOfService => 'Điều khoản dịch vụ';

  @override
  String get profilePrivacyPolicy => 'Chính sách quyền riêng tư';

  @override
  String get profileAboutScanly => 'Về Scanly';

  @override
  String get profileVersionValue => 'Phiên bản 1.0.0';

  @override
  String get profileFeatureComingSoon =>
      'Tính năng này sẽ được bổ sung trong phiên bản tiếp theo.';

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
