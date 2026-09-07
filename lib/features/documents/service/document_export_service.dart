import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as image_library;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf_widgets;

import '../model/document_export_result.dart';
import '../model/stored_document_files.dart';

abstract interface class DocumentExportService {
  Future<DocumentExportResult> export(StoredDocumentFiles files);
}

class LocalDocumentExportService implements DocumentExportService {
  const LocalDocumentExportService();

  static const _maximumPageExtent = 842.0;
  static const _thumbnailWidth = 320;

  @override
  Future<DocumentExportResult> export(StoredDocumentFiles files) async {
    if (files.pages.isEmpty) {
      throw ArgumentError.value(files.pages, 'pages', 'Pages cannot be empty.');
    }

    final pdf = pdf_widgets.Document(
      version: PdfVersion.pdf_1_5,
      compress: true,
    );
    image_library.Image? thumbnailSource;

    try {
      final orderedPages = [...files.pages]
        ..sort((first, second) => first.pageIndex.compareTo(second.pageIndex));
      for (final page in orderedPages) {
        final bytes = await File(page.processedImagePath).readAsBytes();
        image_library.Image? decoded;
        try {
          decoded = image_library.decodeImage(bytes);
        } on Object {
          throw FormatException(
            'Cannot decode processed image: ${page.processedImagePath}',
          );
        }
        if (decoded == null || decoded.width <= 0 || decoded.height <= 0) {
          throw FormatException(
            'Cannot decode processed image: ${page.processedImagePath}',
          );
        }

        thumbnailSource ??= decoded;
        final format = _pageFormat(decoded.width, decoded.height);
        final memoryImage = pdf_widgets.MemoryImage(bytes);
        pdf.addPage(
          pdf_widgets.Page(
            pageFormat: format,
            margin: pdf_widgets.EdgeInsets.zero,
            build: (_) => pdf_widgets.Image(
              memoryImage,
              width: format.width,
              height: format.height,
              fit: pdf_widgets.BoxFit.fill,
            ),
          ),
        );
      }

      final pdfFile = File(files.pdfPath);
      await pdfFile.writeAsBytes(await pdf.save(), flush: true);
      final thumbnail = thumbnailSource;
      if (thumbnail == null) {
        throw StateError('A thumbnail source was not created.');
      }
      await _writeThumbnail(thumbnail, files.thumbnailPath);
      return DocumentExportResult(pdfSizeInBytes: await pdfFile.length());
    } on Object {
      await _deleteIfExists(files.pdfPath);
      await _deleteIfExists(files.thumbnailPath);
      rethrow;
    }
  }

  PdfPageFormat _pageFormat(int width, int height) {
    final scale = _maximumPageExtent / math.max(width, height);
    return PdfPageFormat(width * scale, height * scale, marginAll: 0);
  }

  Future<void> _writeThumbnail(
    image_library.Image source,
    String destinationPath,
  ) async {
    final thumbnail = image_library.copyResize(
      source,
      width: _thumbnailWidth,
      interpolation: image_library.Interpolation.average,
    );
    await File(destinationPath).writeAsBytes(
      image_library.encodeJpg(thumbnail, quality: 82),
      flush: true,
    );
  }

  Future<void> _deleteIfExists(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
