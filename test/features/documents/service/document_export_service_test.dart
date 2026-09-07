import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image_library;
import 'package:scanly/features/documents/model/stored_document_files.dart';
import 'package:scanly/features/documents/service/document_export_service.dart';

void main() {
  late Directory temporaryDirectory;
  const exporter = LocalDocumentExportService();

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'scanly-export-test-',
    );
  });

  tearDown(() async {
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test('creates a PDF and a resized thumbnail from processed pages', () async {
    final firstPage = await _writeImage(
      '${temporaryDirectory.path}/first.png',
      width: 600,
      height: 900,
    );
    final secondPage = await _writeImage(
      '${temporaryDirectory.path}/second.png',
      width: 900,
      height: 600,
    );
    final files = _storedFiles(temporaryDirectory, [secondPage, firstPage]);

    final result = await exporter.export(files);

    final pdfBytes = await File(files.pdfPath).readAsBytes();
    expect(String.fromCharCodes(pdfBytes.take(4)), '%PDF');
    expect(result.pdfSizeInBytes, pdfBytes.length);

    final thumbnail = image_library.decodeJpg(
      await File(files.thumbnailPath).readAsBytes(),
    );
    expect(thumbnail, isNotNull);
    expect(thumbnail!.width, 320);
  });

  test('removes partial output when a processed image is invalid', () async {
    final invalidImage = File('${temporaryDirectory.path}/invalid.jpg');
    await invalidImage.writeAsBytes([1, 2, 3]);
    final files = _storedFiles(temporaryDirectory, [invalidImage]);

    await expectLater(exporter.export(files), throwsA(isA<FormatException>()));

    expect(await File(files.pdfPath).exists(), isFalse);
    expect(await File(files.thumbnailPath).exists(), isFalse);
  });
}

Future<File> _writeImage(
  String path, {
  required int width,
  required int height,
}) async {
  final image = image_library.Image(width: width, height: height);
  image_library.fill(image, color: image_library.ColorRgb8(18, 140, 132));
  final file = File(path);
  await file.writeAsBytes(image_library.encodePng(image));
  return file;
}

StoredDocumentFiles _storedFiles(Directory directory, List<File> pages) {
  return StoredDocumentFiles(
    documentId: 'scan-1',
    directoryPath: directory.path,
    pdfPath: '${directory.path}/document.pdf',
    thumbnailPath: '${directory.path}/thumbnail.jpg',
    pages: [
      for (var index = 0; index < pages.length; index += 1)
        StoredDocumentPageFiles(
          sourcePageId: 'page-$index',
          pageIndex: pages.length - index - 1,
          originalImagePath: pages[index].path,
          normalizedImagePath: pages[index].path,
          processedImagePath: pages[index].path,
        ),
    ],
  );
}
