// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Scanly';

  @override
  String get firebaseNotConfiguredTitle => 'Firebase が未設定です';

  @override
  String get firebaseNotConfiguredBody =>
      'Firebase プロジェクトを作成し、メール/パスワードログインを有効にしてから、このアプリの FlutterFire 設定を実行してください。';

  @override
  String get startupErrorTitle => '起動エラー';

  @override
  String get secureWorkspaceTagline => '安全なドキュメントワークスペース';

  @override
  String get loginWelcomeTitle => 'おかえりなさい';

  @override
  String get loginTitle => 'ログイン';

  @override
  String get loginSubtitle => 'Scanly でドキュメント管理を続けます。';

  @override
  String get emailLabel => 'メール';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get passwordLabel => 'パスワード';

  @override
  String get showPasswordTooltip => 'パスワードを表示';

  @override
  String get hidePasswordTooltip => 'パスワードを非表示';

  @override
  String get loginAction => 'ログイン';

  @override
  String get forgotPasswordAction => 'パスワードを忘れた場合';

  @override
  String get createNewAccountAction => '新しいアカウントを作成';

  @override
  String get orDivider => 'または';

  @override
  String get continueWithGoogle => 'Googleで続行';

  @override
  String get continueWithFacebook => 'Facebookで続行';

  @override
  String get socialLoginComingSoon => 'ソーシャルログインは後ほど追加されます。';

  @override
  String get dontHaveAccountPrompt => 'アカウントをお持ちでないですか？';

  @override
  String get alreadyHaveAccountPrompt => 'すでにアカウントをお持ちですか？';

  @override
  String get authBackendNote =>
      '認証には Firebase を使用します。Node.js API は各リクエストの Firebase ID トークンを検証できます。';

  @override
  String get registerTitle => '登録';

  @override
  String get createAccountTitle => 'アカウント作成';

  @override
  String get registerSubtitle => 'Scanly に参加して、ドキュメント作業をシンプルにしましょう。';

  @override
  String get confirmPasswordLabel => 'パスワードを再入力';

  @override
  String get createAccountAction => 'アカウントを作成';

  @override
  String get emailRequired => 'メールを入力してください。';

  @override
  String get emailInvalid => '有効なメールを入力してください。';

  @override
  String get passwordRequired => 'パスワードを入力してください。';

  @override
  String get passwordMinLength => 'パスワードは6文字以上にしてください。';

  @override
  String get confirmPasswordRequired => 'パスワードを再入力してください。';

  @override
  String get confirmPasswordMismatch => 'パスワードが一致しません。';

  @override
  String get signInSuccess => 'ログインしました。';

  @override
  String get accountCreatedSuccess => 'アカウントを作成しました。';

  @override
  String get passwordResetEmailSent => 'パスワード再設定メールを送信しました。';

  @override
  String get signInFailed => 'ログインに失敗しました。もう一度お試しください。';

  @override
  String get accountCreationFailed => 'アカウント作成に失敗しました。もう一度お試しください。';

  @override
  String get passwordResetFailed => 'パスワード再設定メールを送信できませんでした。もう一度お試しください。';

  @override
  String get signOutFailed => 'ログアウトに失敗しました。もう一度お試しください。';

  @override
  String get invalidEmail => '有効なメールを入力してください。';

  @override
  String get incorrectCredentials => 'メールまたはパスワードが正しくありません。';

  @override
  String get emailAlreadyInUse => 'このメールはすでにアカウントで使用されています。';

  @override
  String get weakPassword => '6文字以上のより強いパスワードを使用してください。';

  @override
  String get userDisabled => 'このアカウントは無効化されています。';

  @override
  String get emailPasswordNotEnabled => 'Firebase でメール/パスワードログインが有効になっていません。';

  @override
  String get tooManyRequests => '試行回数が多すぎます。少し待ってから再試行してください。';

  @override
  String get networkRequestFailed => 'ネットワークエラーです。接続を確認して再試行してください。';

  @override
  String get authenticationFailed => '認証に失敗しました。';

  @override
  String get sessionRestoreFailed => 'ログインセッションを復元できませんでした。';

  @override
  String get tabHome => 'ホーム';

  @override
  String get tabDocuments => '書類';

  @override
  String get tabScan => 'スキャン';

  @override
  String get tabTools => 'ツール';

  @override
  String get tabProfile => 'プロフィール';

  @override
  String get signOutTooltip => 'ログアウト';

  @override
  String get homeWelcomeGeneric => 'おかえりなさい';

  @override
  String get homeWorkspaceSubtitle => 'あなたのドキュメントワークスペース';

  @override
  String get homeScanDocumentAction => '書類をスキャン';

  @override
  String get homeScanDocumentSubtitle => '撮影、切り抜き、補正してPDFに出力';

  @override
  String get homeQuickActionsTitle => 'クイック操作';

  @override
  String get quickImageToPdf => '画像をPDFへ';

  @override
  String get quickImportPdf => 'PDFを読み込む';

  @override
  String get quickOcr => 'OCR';

  @override
  String get quickCompressPdf => 'PDFを圧縮';

  @override
  String get quickSignDocument => '書類に署名';

  @override
  String get quickPasswordProtect => 'パスワード保護';

  @override
  String get homeRecentDocumentsTitle => '最近の書類';

  @override
  String get viewAllAction => 'すべて表示';

  @override
  String get homeNoRecentDocumentsTitle => '最近の書類はまだありません';

  @override
  String get homeNoRecentDocumentsSubtitle => '最初の書類をスキャンして始めましょう。';

  @override
  String get allToolsAction => 'すべて';

  @override
  String get mergePdfAction => 'PDFを結合';

  @override
  String get splitPdfAction => 'PDFを分割';

  @override
  String get reorderPagesAction => 'ページ並べ替え';

  @override
  String get compressPdfAction => 'PDFを圧縮';

  @override
  String get homeScanlyProSubtitle => 'OCR、クラウド同期、無制限のPDFツール。';

  @override
  String get upgradeAction => 'アップグレード';

  @override
  String get readyToScanTitle => 'スキャンの準備ができました';

  @override
  String get authenticatedAccountFallback => 'ログイン中のアカウント';

  @override
  String get scanlyProTitle => 'Scanly Pro';

  @override
  String get scanlyProSubtitle => 'OCR、クラウド同期、高度な PDF 処理を利用するにはアップグレードしてください。';

  @override
  String get nextFeaturesTitle => '次の機能';

  @override
  String get documentScannerTitle => 'ドキュメントスキャナー';

  @override
  String get documentScannerSubtitle => '撮影、紙の端の検出、切り抜き、補正、PDF 出力を行います。';

  @override
  String get nextStatus => '次';

  @override
  String get pdfToolkitTitle => 'PDF ツールキット';

  @override
  String get pdfToolkitSubtitle => '結合、分割、並べ替え、圧縮、パスワード保護、署名に対応します。';

  @override
  String get plannedStatus => '予定';

  @override
  String get ocrSearchTitle => 'OCR 検索';

  @override
  String get ocrSearchSubtitle => '文字を抽出し、ドキュメント内容を検索します。';

  @override
  String get documentsEmptyTitle => '書類はまだありません';

  @override
  String get documentsEmptySubtitle => '保存したスキャンと PDF ファイルがここに表示されます。';

  @override
  String get searchDocumentsHint => '書類を検索';

  @override
  String get documentsFilterTitle => '書類を絞り込む';

  @override
  String get documentFilterAll => 'すべて';

  @override
  String get documentFilterScans => 'スキャン';

  @override
  String get documentFilterPdfs => 'PDF';

  @override
  String get clearSearchAction => '検索をクリア';

  @override
  String get documentsComingNextTitle => '今後の機能';

  @override
  String get documentStorageTitle => '書類ストレージ';

  @override
  String get documentStorageSubtitle => 'ファイルを安全に保存・整理';

  @override
  String get searchDocumentsTitle => '書類検索';

  @override
  String get searchDocumentsSubtitle => '必要なファイルをすぐに検索';

  @override
  String get ocrContentSearchTitle => 'OCR 内容検索';

  @override
  String get ocrContentSearchSubtitle => '書類内の文字を検索';

  @override
  String get documentsCountLabel => '件';

  @override
  String get sortRecent => '新しい順';

  @override
  String get sortOldest => '古い順';

  @override
  String get ocrReadyLabel => 'OCR 済み';

  @override
  String get openAction => '開く';

  @override
  String get renameAction => '名前を変更';

  @override
  String get shareAction => '共有';

  @override
  String get moveAction => '移動';

  @override
  String get deleteAction => '削除';

  @override
  String get documentsFeatureComingSoon => '書類機能は今後追加されます。';

  @override
  String get noMatchingDocumentsTitle => '該当する書類がありません';

  @override
  String get noMatchingDocumentsSubtitle => '別のキーワードやフィルターをお試しください。';

  @override
  String get pageLabel => 'ページ';

  @override
  String get pagesLabel => 'ページ';

  @override
  String get scanPageTitle => '新しい書類をスキャン';

  @override
  String get scanPageSubtitle => 'カメラを開いて紙の端を検出し、傾きを補正して文字を見やすくし、PDF に出力します。';

  @override
  String get startScanAction => 'スキャンを開始';

  @override
  String get cameraPermissionRequesting => 'カメラへのアクセスを確認しています...';

  @override
  String get cameraInitializing => 'カメラを起動しています...';

  @override
  String get imageNormalizing => '撮影した画像を準備しています...';

  @override
  String get documentEdgesDetecting => '書類の端を検出しています...';

  @override
  String get imageNormalizationFailureTitle => '画像を準備できません';

  @override
  String get imageNormalizationFailureMessage =>
      '撮影した画像を読み込み、向きを補正できませんでした。もう一度撮影してください。';

  @override
  String get cameraPermissionDeniedTitle => 'カメラへのアクセスが必要です';

  @override
  String get cameraPermissionDeniedMessage =>
      '書類を撮影・スキャンするため、Scanly にカメラの使用を許可してください。';

  @override
  String get cameraPermissionPermanentlyDeniedTitle => 'カメラへのアクセスがオフです';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'スキャンを続けるには、設定を開いて Scanly のカメラアクセスを許可してください。';

  @override
  String get cameraRestrictedTitle => 'カメラを使用できません';

  @override
  String get cameraRestrictedMessage =>
      'この端末ではカメラの使用が制限されています。システムの制限を確認するか、端末の管理者にお問い合わせください。';

  @override
  String get cameraUnavailableTitle => 'カメラが見つかりません';

  @override
  String get cameraUnavailableMessage => 'この端末には書類のスキャンに使用できるカメラがありません。';

  @override
  String get cameraFailureTitle => 'カメラを開けません';

  @override
  String get cameraFailureMessage => 'カメラを開く際にエラーが発生しました。もう一度お試しください。';

  @override
  String get retryAction => '再試行';

  @override
  String get openSettingsAction => '設定を開く';

  @override
  String get captureDocumentTooltip => '書類を撮影';

  @override
  String get scanCapturedMessage => '書類を撮影しました。';

  @override
  String get scanEditorTitle => 'スキャンを確認';

  @override
  String scanEditorPageProgress(int current, int total) {
    return '$total ページ中 $current ページ';
  }

  @override
  String scanEditorPageNumber(int number) {
    return '$number ページ';
  }

  @override
  String get scanEditorAdd => '追加';

  @override
  String get scanEditorAddPage => 'ページを追加';

  @override
  String get scanEditorDeletePage => 'ページを削除';

  @override
  String get scanEditorReorderHint => '長押ししてドラッグで並べ替え';

  @override
  String get scanEditorCancel => 'キャンセル';

  @override
  String get scanEditorContinue => '続ける';

  @override
  String get scanEditorEmptyTitle => 'スキャンしたページがありません';

  @override
  String get scanEditorEmptySubtitle => 'ページを撮影して、このスキャンを続けてください。';

  @override
  String get scanEditorDiscardTitle => 'このスキャンを破棄しますか？';

  @override
  String get scanEditorDiscardMessage => 'このセッションで撮影したすべてのページが削除されます。';

  @override
  String get scanEditorKeepEditing => '編集を続ける';

  @override
  String get scanEditorDiscard => '破棄';

  @override
  String get documentEdgesDetected => '書類の端を検出しました';

  @override
  String get documentEdgesNotFound => '書類の端が見つかりませんでした。四隅を手動で調整してください。';

  @override
  String get documentEdgeDetectionFailed => '端を検出できませんでした。四隅を手動で調整してください。';

  @override
  String get documentCornersAdjusted => '書類の四隅を調整しました';

  @override
  String get documentPerspectiveCorrecting => '切り抜きと遠近補正を処理中...';

  @override
  String get documentPerspectiveCorrected => '遠近補正が完了しました';

  @override
  String get documentPerspectiveCorrectionFailed => 'このページを処理できませんでした。';

  @override
  String get documentPerspectiveRetry => '処理を再試行';

  @override
  String get scanAdjustCorners => '調整';

  @override
  String get scanCornerEditorTitle => '四隅を調整';

  @override
  String get scanCornerEditorHint => '各ポイントを書類の端に合わせてドラッグしてください。';

  @override
  String get scanCornerInvalidMessage => '書類を囲む正しい順序で四隅を配置してください。';

  @override
  String get scanCornerReset => 'リセット';

  @override
  String get scanCornerSave => '四隅を保存';

  @override
  String get scanCornerTopLeft => '左上の角';

  @override
  String get scanCornerTopRight => '右上の角';

  @override
  String get scanCornerBottomRight => '右下の角';

  @override
  String get scanCornerBottomLeft => '左下の角';

  @override
  String get scanPdfComingSoon => 'PDF 作成機能は次のステップで追加されます。';

  @override
  String pdfSelectedMessage(String name) {
    return '$name を選択しました。';
  }

  @override
  String get pdfImportFailed => 'PDF ファイルを開けませんでした。もう一度お試しください。';

  @override
  String get toolsPageTitle => 'PDF ツール';

  @override
  String get toolsPageSubtitle => '書類の編集、変換、保護を行います';

  @override
  String get toolsEditOrganizeTitle => '編集と整理';

  @override
  String get toolsConvertExtractTitle => '変換と抽出';

  @override
  String get toolsOptimizeTitle => '最適化';

  @override
  String get toolsSecurityTitle => 'セキュリティ';

  @override
  String get deletePagesAction => 'ページを削除';

  @override
  String get ocrTextAction => 'OCR テキスト';

  @override
  String get toolsFeatureComingSoon => 'このツールは今後のバージョンで追加されます。';

  @override
  String get profileAccountTitle => 'アカウント';

  @override
  String get profileSettingsTitle => '設定';

  @override
  String get profileFreePlan => '無料プラン';

  @override
  String get profileUpgradeToPro => 'Scanly Proにアップグレード';

  @override
  String get profileAppearanceTitle => '外観';

  @override
  String get profileThemeSettingTitle => '表示モード';

  @override
  String get themeModeLight => 'ライト';

  @override
  String get themeModeDark => 'ダーク';

  @override
  String get profileLanguageSectionTitle => '言語';

  @override
  String get profileAccountSecurityTitle => 'アカウントとセキュリティ';

  @override
  String get profileAccountInformation => 'アカウント情報';

  @override
  String get profileChangePassword => 'パスワードを変更';

  @override
  String get profilePrivacySecurity => 'プライバシーとセキュリティ';

  @override
  String get profileInformationSupportTitle => '情報とサポート';

  @override
  String get profileTermsOfService => '利用規約';

  @override
  String get profilePrivacyPolicy => 'プライバシーポリシー';

  @override
  String get profileAboutScanly => 'Scanlyについて';

  @override
  String get profileVersionValue => 'バージョン 1.0.0';

  @override
  String get profileFeatureComingSoon => 'この機能は今後のバージョンで追加されます。';

  @override
  String get languageSettingTitle => '言語';

  @override
  String get languageSettingSubtitle => 'Scanly の表示言語を選択します。';

  @override
  String get languagePickerTitle => '言語を選択';

  @override
  String get languageVietnamese => 'ベトナム語';

  @override
  String get languageEnglish => '英語';

  @override
  String get languageJapanese => '日本語';

  @override
  String get cloudSyncTitle => 'クラウド同期';

  @override
  String get cloudSyncSubtitle => 'バックエンド準備後に追加予定です。';

  @override
  String get signOutAction => 'ログアウト';
}
