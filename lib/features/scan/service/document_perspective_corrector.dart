import 'dart:io';

import 'package:document_scan/document_scan.dart' as document_scan;

import '../model/document_corners.dart';
import '../model/processed_document_image.dart';

enum PerspectiveCorrectionFailure {
  sourceNotFound,
  invalidCorners,
  imageDecodeFailed,
  processingFailed,
  outputWriteFailed,
}

class PerspectiveCorrectionException implements Exception {
  const PerspectiveCorrectionException(this.failure, [this.cause]);

  final PerspectiveCorrectionFailure failure;
  final Object? cause;
}

abstract interface class DocumentPerspectiveCorrector {
  Future<ProcessedDocumentImage> correct({
    required String normalizedImagePath,
    required DocumentCorners corners,
  });
}

typedef ProcessedImagePathBuilder = String Function(String sourcePath);

class LocalDocumentPerspectiveCorrector
    implements DocumentPerspectiveCorrector {
  LocalDocumentPerspectiveCorrector({
    document_scan.DocumentProcessor? processor,
    ProcessedImagePathBuilder? outputPathBuilder,
  }) : _processor = processor ?? const document_scan.DocumentProcessor(),
       _outputPathBuilder = outputPathBuilder ?? _defaultOutputPath;

  final document_scan.DocumentProcessor _processor;
  final ProcessedImagePathBuilder _outputPathBuilder;

  @override
  Future<ProcessedDocumentImage> correct({
    required String normalizedImagePath,
    required DocumentCorners corners,
  }) async {
    if (!corners.isUsable) {
      throw const PerspectiveCorrectionException(
        PerspectiveCorrectionFailure.invalidCorners,
      );
    }
    if (!await File(normalizedImagePath).exists()) {
      throw const PerspectiveCorrectionException(
        PerspectiveCorrectionFailure.sourceNotFound,
      );
    }

    late final document_scan.ScannedDocument? result;
    try {
      result = await _processor.crop(
        document_scan.ScanInput.file(normalizedImagePath),
        _mapCorners(corners),
        output: const document_scan.ScanOutputFormat.jpegAt(95),
        background: true,
      );
    } on Object catch (error) {
      throw PerspectiveCorrectionException(
        PerspectiveCorrectionFailure.processingFailed,
        error,
      );
    }
    if (result == null) {
      throw const PerspectiveCorrectionException(
        PerspectiveCorrectionFailure.imageDecodeFailed,
      );
    }

    final outputPath = _outputPathBuilder(normalizedImagePath);
    try {
      await File(outputPath).writeAsBytes(result.bytes, flush: true);
    } on Object catch (error) {
      throw PerspectiveCorrectionException(
        PerspectiveCorrectionFailure.outputWriteFailed,
        error,
      );
    }

    return ProcessedDocumentImage(
      imagePath: outputPath,
      pixelWidth: result.width,
      pixelHeight: result.height,
    );
  }
}

document_scan.DocumentCorners _mapCorners(DocumentCorners corners) {
  return document_scan.DocumentCorners(
    topLeft: (x: corners.topLeft.x, y: corners.topLeft.y),
    topRight: (x: corners.topRight.x, y: corners.topRight.y),
    bottomRight: (x: corners.bottomRight.x, y: corners.bottomRight.y),
    bottomLeft: (x: corners.bottomLeft.x, y: corners.bottomLeft.y),
    confidence: corners.confidence,
  );
}

String _defaultOutputPath(String sourcePath) {
  final slashIndex = sourcePath.lastIndexOf(RegExp(r'[/\\]'));
  final extensionIndex = sourcePath.lastIndexOf('.');
  final hasExtension = extensionIndex > slashIndex;
  final basePath = hasExtension
      ? sourcePath.substring(0, extensionIndex)
      : sourcePath;
  final timestamp = DateTime.now().microsecondsSinceEpoch;
  return '${basePath}_perspective_$timestamp.jpg';
}
