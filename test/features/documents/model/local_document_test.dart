import 'package:flutter_test/flutter_test.dart';
import 'package:scanly/features/documents/model/ocr_status.dart';
import 'package:scanly/features/documents/model/sync_status.dart';
import 'package:scanly/features/documents/model/local_document.dart';
import 'package:scanly/features/documents/model/local_document_page.dart';
import 'package:scanly/features/scan/model/document_corners.dart';
import 'package:scanly/features/scan/model/scan_filter.dart';

void main() {
  final createdAt = DateTime.utc(2026, 9, 7, 10);
  final updatedAt = DateTime.utc(2026, 9, 7, 11);

  test('local document keeps persistent metadata and supports copyWith', () {
    final document = LocalDocument(
      id: 'document-1',
      name: 'Invoice',
      pdfPath: '/documents/document-1/document.pdf',
      thumbnailPath: '/documents/document-1/thumbnail.jpg',
      pageCount: 2,
      sizeInBytes: 4096,
      createdAt: createdAt,
      updatedAt: createdAt,
    );

    final updated = document.copyWith(
      name: 'September invoice',
      updatedAt: updatedAt,
      ocrStatus: DocumentOcrStatus.pending,
      syncStatus: DocumentSyncStatus.pendingUpload,
    );

    expect(updated.id, document.id);
    expect(updated.pdfPath, document.pdfPath);
    expect(updated.name, 'September invoice');
    expect(updated.updatedAt, updatedAt);
    expect(updated.ocrStatus, DocumentOcrStatus.pending);
    expect(updated.syncStatus, DocumentSyncStatus.pendingUpload);
  });

  test('local document page preserves scan editing metadata', () {
    final page = LocalDocumentPage(
      id: 'page-1',
      documentId: 'document-1',
      pageIndex: 0,
      originalImagePath: '/documents/document-1/pages/page-001-original.jpg',
      normalizedImagePath:
          '/documents/document-1/pages/page-001-normalized.jpg',
      processedImagePath: '/documents/document-1/pages/page-001-processed.jpg',
      originalPixelWidth: 2400,
      originalPixelHeight: 3600,
      processedPixelWidth: 1200,
      processedPixelHeight: 1800,
      corners: DocumentCorners.fullImage,
      rotation: 270,
      filter: ScanFilter.blackAndWhite,
      brightness: 15,
      contrast: 30,
      createdAt: createdAt,
      updatedAt: createdAt,
    );

    final reordered = page.copyWith(pageIndex: 1, updatedAt: updatedAt);

    expect(reordered.pageIndex, 1);
    expect(reordered.rotation, 270);
    expect(reordered.filter, ScanFilter.blackAndWhite);
    expect(reordered.brightness, 15);
    expect(reordered.contrast, 30);
    expect(reordered.corners, DocumentCorners.fullImage);
  });
}
