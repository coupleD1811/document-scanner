import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as image_library;
import 'package:pdfx/pdfx.dart';

import '../../scan/model/document_corners.dart';
import '../../scan/model/scan_filter.dart';
import '../model/imported_pdf_preview.dart';
import '../model/page_save_draft.dart';
import '../model/save_draft.dart';

enum DocumentImportFailureReason {
  sourceUnavailable,
  unsupportedImage,
  fileTooLarge,
  passwordProtectedPdf,
  invalidPdf,
}

class DocumentImportException implements Exception {
  const DocumentImportException(this.reason, [this.cause]);

  final DocumentImportFailureReason reason;
  final Object? cause;

  @override
  String toString() => 'DocumentImportException($reason)';
}

abstract interface class DocumentImportService {
  Future<DocumentSaveDraft> createImageDraft({
    required List<String> sourcePaths,
    required String name,
  });

  Future<ImportedPdfPreview> createPdfPreview(String sourcePath);
}

typedef DocumentImportClock = DateTime Function();
typedef DocumentImportIdGenerator = String Function();

class LocalDocumentImportService implements DocumentImportService {
  LocalDocumentImportService({
    DocumentImportClock? clock,
    DocumentImportIdGenerator? idGenerator,
  }) : _clock = clock ?? DateTime.now,
       _idGenerator = idGenerator ?? _createId;

  static const _maximumFileSize = 100 * 1024 * 1024;
  static const _pdfTrailerProbeSize = 128 * 1024;
  static const _thumbnailWidth = 320;

  final DocumentImportClock _clock;
  final DocumentImportIdGenerator _idGenerator;

  @override
  Future<DocumentSaveDraft> createImageDraft({
    required List<String> sourcePaths,
    required String name,
  }) async {
    if (sourcePaths.isEmpty) {
      throw const DocumentImportException(
        DocumentImportFailureReason.sourceUnavailable,
      );
    }

    final createdAt = _clock().toUtc();
    final documentId = _idGenerator();
    final pages = <DocumentPageSaveDraft>[];
    for (var index = 0; index < sourcePaths.length; index++) {
      final sourcePath = sourcePaths[index];
      final image = await _decodeImage(sourcePath);
      pages.add(
        DocumentPageSaveDraft(
          sourcePageId: '$documentId-page-${index + 1}',
          pageIndex: index,
          originalImagePath: sourcePath,
          normalizedImagePath: sourcePath,
          processedImagePath: sourcePath,
          originalPixelWidth: image.width,
          originalPixelHeight: image.height,
          processedPixelWidth: image.width,
          processedPixelHeight: image.height,
          corners: DocumentCorners.fullImage,
          rotation: 0,
          filter: ScanFilter.original,
          brightness: 0,
          contrast: 0,
          createdAt: createdAt,
        ),
      );
    }

    return DocumentSaveDraft(
      sourceSessionId: documentId,
      name: name,
      pages: pages,
      createdAt: createdAt,
    );
  }

  @override
  Future<ImportedPdfPreview> createPdfPreview(String sourcePath) async {
    final source = await _checkedFile(sourcePath);
    if (await _hasEncryptionMarker(source)) {
      throw const DocumentImportException(
        DocumentImportFailureReason.passwordProtectedPdf,
      );
    }
    PdfDocument? document;
    PdfPage? page;
    try {
      document = await PdfDocument.openFile(source.path);
      if (document.pagesCount < 1) {
        throw const DocumentImportException(
          DocumentImportFailureReason.invalidPdf,
        );
      }
      page = await document.getPage(1);
      if (page.width <= 0 || page.height <= 0) {
        throw const DocumentImportException(
          DocumentImportFailureReason.invalidPdf,
        );
      }
      final thumbnailHeight = max(
        1,
        (page.height * _thumbnailWidth / page.width).round(),
      );
      final rendered = await page.render(
        width: _thumbnailWidth.toDouble(),
        height: thumbnailHeight.toDouble(),
        format: PdfPageImageFormat.jpeg,
        quality: 82,
        backgroundColor: '#ffffff',
      );
      if (rendered == null || rendered.bytes.isEmpty) {
        throw const DocumentImportException(
          DocumentImportFailureReason.invalidPdf,
        );
      }
      return ImportedPdfPreview(
        documentId: _idGenerator(),
        pageCount: document.pagesCount,
        thumbnailBytes: rendered.bytes,
        thumbnailWidth: _thumbnailWidth,
        thumbnailHeight: thumbnailHeight,
      );
    } on DocumentImportException {
      rethrow;
    } on Object catch (error) {
      throw DocumentImportException(_pdfFailureReason(error), error);
    } finally {
      await page?.close();
      await document?.close();
    }
  }

  Future<image_library.Image> _decodeImage(String sourcePath) async {
    final source = await _checkedFile(sourcePath);
    final decoded = image_library.decodeImage(await source.readAsBytes());
    if (decoded == null || decoded.width <= 0 || decoded.height <= 0) {
      throw const DocumentImportException(
        DocumentImportFailureReason.unsupportedImage,
      );
    }
    return decoded;
  }

  Future<File> _checkedFile(String sourcePath) async {
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw const DocumentImportException(
        DocumentImportFailureReason.sourceUnavailable,
      );
    }
    if (await source.length() > _maximumFileSize) {
      throw const DocumentImportException(
        DocumentImportFailureReason.fileTooLarge,
      );
    }
    return source;
  }

  Future<bool> _hasEncryptionMarker(File source) async {
    final length = await source.length();
    final handle = await source.open();
    try {
      final start = max(0, length - _pdfTrailerProbeSize);
      await handle.setPosition(start);
      final bytes = await handle.read(length - start);
      return _containsAscii(bytes, '/Encrypt');
    } finally {
      await handle.close();
    }
  }

  bool _containsAscii(List<int> bytes, String value) {
    final pattern = value.codeUnits;
    if (pattern.length > bytes.length) {
      return false;
    }
    for (var index = 0; index <= bytes.length - pattern.length; index++) {
      var matches = true;
      for (
        var patternIndex = 0;
        patternIndex < pattern.length;
        patternIndex++
      ) {
        if (bytes[index + patternIndex] != pattern[patternIndex]) {
          matches = false;
          break;
        }
      }
      if (matches) {
        return true;
      }
    }
    return false;
  }

  DocumentImportFailureReason _pdfFailureReason(Object error) {
    final details = error.toString().toLowerCase();
    if (details.contains('password') ||
        details.contains('encrypted') ||
        details.contains('securityexception')) {
      return DocumentImportFailureReason.passwordProtectedPdf;
    }
    return DocumentImportFailureReason.invalidPdf;
  }

  static String _createId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final randomValue = Random.secure().nextInt(1 << 32).toRadixString(16);
    return 'import-$timestamp-$randomValue';
  }
}
