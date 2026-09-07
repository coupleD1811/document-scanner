import '../../scan/model/document_page.dart';
import '../../scan/model/document_processing_status.dart';
import '../../scan/model/scan_session.dart';
import '../model/page_save_draft.dart';
import '../model/save_draft.dart';

enum ScanSessionDocumentMappingFailure {
  invalidName,
  invalidSession,
  emptySession,
  pageNotReady,
}

class ScanSessionDocumentMappingException implements Exception {
  const ScanSessionDocumentMappingException(this.failure, {this.pageId});

  final ScanSessionDocumentMappingFailure failure;
  final String? pageId;
}

class ScanSessionDocumentMapper {
  const ScanSessionDocumentMapper();

  DocumentSaveDraft map({required ScanSession session, required String name}) {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw const ScanSessionDocumentMappingException(
        ScanSessionDocumentMappingFailure.invalidName,
      );
    }
    if (session.id.isEmpty) {
      throw const ScanSessionDocumentMappingException(
        ScanSessionDocumentMappingFailure.invalidSession,
      );
    }
    if (session.pages.isEmpty) {
      throw const ScanSessionDocumentMappingException(
        ScanSessionDocumentMappingFailure.emptySession,
      );
    }

    return DocumentSaveDraft(
      sourceSessionId: session.id,
      name: normalizedName,
      pages: [
        for (var index = 0; index < session.pages.length; index += 1)
          _mapPage(session.pages[index], index),
      ],
      createdAt: session.createdAt,
    );
  }

  DocumentPageSaveDraft _mapPage(DocumentPage page, int pageIndex) {
    final processedImagePath = page.processedImagePath;
    final processedPixelWidth = page.processedPixelWidth;
    final processedPixelHeight = page.processedPixelHeight;
    if (page.processingStatus != DocumentProcessingStatus.completed ||
        processedImagePath == null ||
        processedImagePath.isEmpty ||
        processedPixelWidth == null ||
        processedPixelHeight == null ||
        !page.corners.isUsable) {
      throw ScanSessionDocumentMappingException(
        ScanSessionDocumentMappingFailure.pageNotReady,
        pageId: page.id,
      );
    }

    return DocumentPageSaveDraft(
      sourcePageId: page.id,
      pageIndex: pageIndex,
      originalImagePath: page.originalImagePath,
      normalizedImagePath: page.normalizedImagePath,
      processedImagePath: processedImagePath,
      originalPixelWidth: page.pixelWidth,
      originalPixelHeight: page.pixelHeight,
      processedPixelWidth: processedPixelWidth,
      processedPixelHeight: processedPixelHeight,
      corners: page.corners,
      rotation: page.rotation,
      filter: page.filter,
      brightness: page.brightness,
      contrast: page.contrast,
      createdAt: page.createdAt,
    );
  }
}
