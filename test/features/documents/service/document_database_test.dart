import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scanly/features/documents/model/local_document.dart';
import 'package:scanly/features/documents/model/local_document_page.dart';
import 'package:scanly/features/documents/model/ocr_status.dart';
import 'package:scanly/features/documents/model/sync_status.dart';
import 'package:scanly/features/documents/service/database/document_database.dart';
import 'package:scanly/features/scan/model/document_corners.dart';
import 'package:scanly/features/scan/model/normalized_point.dart';
import 'package:scanly/features/scan/model/scan_filter.dart';

void main() {
  late DocumentDatabase database;

  setUp(() {
    database = DocumentDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('stores and restores a document with ordered page metadata', () async {
    final createdAt = DateTime.utc(2026, 9, 7, 8);
    final document = _document(createdAt);
    final pages = [
      _page(index: 1, createdAt: createdAt, filter: ScanFilter.grayscale),
      _page(index: 0, createdAt: createdAt, filter: ScanFilter.color),
    ];

    await database.saveDocument(document, pages);

    expect(await database.getDocuments(), [document]);
    final restoredPages = await database.getDocumentPages(document.id);
    expect(restoredPages.map((page) => page.pageIndex), [0, 1]);
    expect(restoredPages[0], pages[1]);
    expect(restoredPages[1], pages[0]);
  });

  test('renames a document and cascades deletion to its pages', () async {
    final createdAt = DateTime.utc(2026, 9, 7, 8);
    final document = _document(createdAt).copyWith(pageCount: 1);
    await database.saveDocument(document, [
      _page(index: 0, createdAt: createdAt, filter: ScanFilter.original),
    ]);

    final renamedAt = createdAt.add(const Duration(minutes: 5));
    await database.renameDocument(
      documentId: document.id,
      name: 'Renamed scan.pdf',
      updatedAt: renamedAt,
    );

    final renamed = (await database.getDocuments()).single;
    expect(renamed.name, 'Renamed scan.pdf');
    expect(renamed.updatedAt, renamedAt);

    await database.deleteDocument(document.id);
    expect(await database.getDocuments(), isEmpty);
    expect(await database.getDocumentPages(document.id), isEmpty);
  });

  test('restores documents after reopening a file database', () async {
    await database.close();
    final directory = await Directory.systemTemp.createTemp(
      'scanly-database-test-',
    );
    final databaseFile = File('${directory.path}/documents.sqlite');
    final createdAt = DateTime.utc(2026, 9, 7, 8);
    final document = _document(createdAt).copyWith(pageCount: 1);

    try {
      database = DocumentDatabase(NativeDatabase(databaseFile));
      await database.saveDocument(document, [
        _page(index: 0, createdAt: createdAt, filter: ScanFilter.original),
      ]);
      await database.close();

      database = DocumentDatabase(NativeDatabase(databaseFile));
      expect(await database.getDocuments(), [document]);
      expect(await database.getDocumentPages(document.id), hasLength(1));
    } finally {
      await database.close();
      database = DocumentDatabase(NativeDatabase.memory());
      await directory.delete(recursive: true);
    }
  });
}

LocalDocument _document(DateTime createdAt) {
  return LocalDocument(
    id: 'document-1',
    name: 'Scan.pdf',
    pdfPath: '/documents/document-1/scan.pdf',
    thumbnailPath: '/documents/document-1/thumbnail.jpg',
    pageCount: 2,
    sizeInBytes: 4096,
    createdAt: createdAt,
    updatedAt: createdAt,
    ocrStatus: DocumentOcrStatus.pending,
    syncStatus: DocumentSyncStatus.localOnly,
  );
}

LocalDocumentPage _page({
  required int index,
  required DateTime createdAt,
  required ScanFilter filter,
}) {
  return LocalDocumentPage(
    id: 'page-$index',
    documentId: 'document-1',
    pageIndex: index,
    originalImagePath: '/documents/document-1/pages/$index-original.jpg',
    normalizedImagePath: '/documents/document-1/pages/$index-normalized.jpg',
    processedImagePath: '/documents/document-1/pages/$index-processed.jpg',
    originalPixelWidth: 2000,
    originalPixelHeight: 3000,
    processedPixelWidth: 1400,
    processedPixelHeight: 2000,
    corners: const DocumentCorners(
      topLeft: NormalizedPoint(x: 0.1, y: 0.1),
      topRight: NormalizedPoint(x: 0.9, y: 0.1),
      bottomRight: NormalizedPoint(x: 0.9, y: 0.9),
      bottomLeft: NormalizedPoint(x: 0.1, y: 0.9),
      source: DocumentCornersSource.detected,
      confidence: 0.92,
    ),
    rotation: index == 0 ? 90 : 0,
    filter: filter,
    brightness: 8,
    contrast: -4,
    createdAt: createdAt,
    updatedAt: createdAt,
  );
}
