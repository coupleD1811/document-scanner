import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:scanly/features/documents/model/page_save_draft.dart';
import 'package:scanly/features/documents/model/save_draft.dart';
import 'package:scanly/features/documents/service/document_storage_service.dart';
import 'package:scanly/features/scan/model/document_corners.dart';
import 'package:scanly/features/scan/model/scan_filter.dart';

void main() {
  late Directory temporaryDirectory;
  late Directory sourceDirectory;
  late DocumentStorageService storage;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'scanly-storage-test-',
    );
    sourceDirectory = Directory('${temporaryDirectory.path}/source');
    await sourceDirectory.create();
    storage = DocumentStorageService(
      rootDirectoryLoader: () async => temporaryDirectory,
    );
  });

  tearDown(() async {
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test('copies every page image into the document directory', () async {
    final draft = await _createDraft(sourceDirectory);

    final result = await storage.storePageImages(draft);

    expect(result.documentId, draft.sourceSessionId);
    expect(result.pages, hasLength(1));
    expect(await File(result.pages.single.originalImagePath).readAsBytes(), [
      1,
      2,
      3,
    ]);
    expect(
      await File(result.pages.single.normalizedImagePath).exists(),
      isTrue,
    );
    expect(await File(result.pages.single.processedImagePath).exists(), isTrue);
    expect(result.pdfPath, endsWith('/document.pdf'));
    expect(result.thumbnailPath, endsWith('/thumbnail.jpg'));
  });

  test('removes a partial directory when a source image is missing', () async {
    final draft = await _createDraft(
      sourceDirectory,
      processedPath: '${sourceDirectory.path}/missing.jpg',
    );

    await expectLater(
      storage.storePageImages(draft),
      throwsA(isA<FileSystemException>()),
    );

    final documentDirectory = Directory(
      '${temporaryDirectory.path}/scanly/documents/scan-1',
    );
    expect(await documentDirectory.exists(), isFalse);
  });
}

Future<DocumentSaveDraft> _createDraft(
  Directory sourceDirectory, {
  String? processedPath,
}) async {
  final original = File('${sourceDirectory.path}/original.jpg');
  final normalized = File('${sourceDirectory.path}/normalized.png');
  final processed = File('${sourceDirectory.path}/processed.jpg');
  await original.writeAsBytes([1, 2, 3]);
  await normalized.writeAsBytes([4, 5, 6]);
  await processed.writeAsBytes([7, 8, 9]);
  final createdAt = DateTime.utc(2026, 9, 7);

  return DocumentSaveDraft(
    sourceSessionId: 'scan-1',
    name: 'Scan.pdf',
    createdAt: createdAt,
    pages: [
      DocumentPageSaveDraft(
        sourcePageId: 'page-1',
        pageIndex: 0,
        originalImagePath: original.path,
        normalizedImagePath: normalized.path,
        processedImagePath: processedPath ?? processed.path,
        originalPixelWidth: 1200,
        originalPixelHeight: 1800,
        processedPixelWidth: 1000,
        processedPixelHeight: 1400,
        corners: DocumentCorners.fullImage,
        rotation: 0,
        filter: ScanFilter.original,
        brightness: 0,
        contrast: 0,
        createdAt: createdAt,
      ),
    ],
  );
}
