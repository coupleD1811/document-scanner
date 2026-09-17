import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image_library;
import 'package:scanly/features/documents/service/document_import_service.dart';
import 'package:scanly/features/scan/model/document_corners.dart';
import 'package:scanly/features/scan/model/scan_filter.dart';

void main() {
  late Directory temporaryDirectory;
  late LocalDocumentImportService service;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'scanly-import-',
    );
    service = LocalDocumentImportService(
      clock: () => DateTime.utc(2026, 9, 17, 10),
      idGenerator: () => 'import-test',
    );
  });

  tearDown(() async {
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test('creates a neutral multi-page draft from supported images', () async {
    final firstImage = await _writeImage(
      temporaryDirectory,
      'first.jpg',
      width: 12,
      height: 8,
    );
    final secondImage = await _writeImage(
      temporaryDirectory,
      'second.png',
      width: 6,
      height: 9,
    );

    final draft = await service.createImageDraft(
      sourcePaths: [firstImage.path, secondImage.path],
      name: 'Imported images',
    );

    expect(draft.sourceSessionId, 'import-test');
    expect(draft.pageCount, 2);
    expect(draft.pages.first.sourcePageId, 'import-test-page-1');
    expect(draft.pages.last.sourcePageId, 'import-test-page-2');
    expect(draft.pages.first.originalPixelWidth, 12);
    expect(draft.pages.first.originalPixelHeight, 8);
    expect(draft.pages.last.originalPixelWidth, 6);
    expect(draft.pages.last.originalPixelHeight, 9);
    for (final page in draft.pages) {
      expect(page.corners, DocumentCorners.fullImage);
      expect(page.filter, ScanFilter.original);
      expect(page.rotation, 0);
      expect(page.brightness, 0);
      expect(page.contrast, 0);
      expect(page.originalImagePath, page.normalizedImagePath);
      expect(page.originalImagePath, page.processedImagePath);
    }
  });

  test('rejects an unreadable image', () async {
    final invalidFile = File('${temporaryDirectory.path}/invalid.jpg');
    await invalidFile.writeAsString('not an image');

    await expectLater(
      service.createImageDraft(
        sourcePaths: [invalidFile.path],
        name: 'Invalid image',
      ),
      throwsA(
        isA<DocumentImportException>().having(
          (error) => error.reason,
          'reason',
          DocumentImportFailureReason.unsupportedImage,
        ),
      ),
    );
  });
}

Future<File> _writeImage(
  Directory directory,
  String name, {
  required int width,
  required int height,
}) async {
  final image = image_library.Image(width: width, height: height);
  final file = File('${directory.path}/$name');
  final bytes = name.endsWith('.png')
      ? image_library.encodePng(image)
      : image_library.encodeJpg(image);
  await file.writeAsBytes(bytes);
  return file;
}
