import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:document_scan/document_scan.dart' as document_scan;
import 'package:image/image.dart' as img;

import '../model/document_corners.dart';
import '../model/processed_document_image.dart';

enum PerspectiveCorrectionFailure {
  sourceNotFound,
  invalidCorners,
  invalidRotation,
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
    int rotationDegrees = 0,
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
    int rotationDegrees = 0,
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
    if (rotationDegrees % 90 != 0) {
      throw const PerspectiveCorrectionException(
        PerspectiveCorrectionFailure.invalidRotation,
      );
    }
    final normalizedRotation = _normalizeRotation(rotationDegrees);

    late final document_scan.ScannedDocument? result;
    try {
      result = await _processor.crop(
        document_scan.ScanInput.file(normalizedImagePath),
        _mapCorners(corners),
        output: normalizedRotation == 0
            ? const document_scan.ScanOutputFormat.jpegAt(95)
            : document_scan.ScanOutputFormat.png,
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

    late final _EncodedDocumentImage processedImage;
    if (normalizedRotation == 0) {
      processedImage = _EncodedDocumentImage(
        bytes: result.bytes,
        width: result.width,
        height: result.height,
      );
    } else {
      try {
        final rotatedImage = await Isolate.run(
          () => _rotateAndEncode(result!.bytes, normalizedRotation),
        );
        if (rotatedImage == null) {
          throw const PerspectiveCorrectionException(
            PerspectiveCorrectionFailure.imageDecodeFailed,
          );
        }
        processedImage = rotatedImage;
      } on PerspectiveCorrectionException {
        rethrow;
      } on Object catch (error) {
        throw PerspectiveCorrectionException(
          PerspectiveCorrectionFailure.processingFailed,
          error,
        );
      }
    }

    final outputPath = _outputPathBuilder(normalizedImagePath);
    try {
      await File(outputPath).writeAsBytes(processedImage.bytes, flush: true);
    } on Object catch (error) {
      throw PerspectiveCorrectionException(
        PerspectiveCorrectionFailure.outputWriteFailed,
        error,
      );
    }

    return ProcessedDocumentImage(
      imagePath: outputPath,
      pixelWidth: processedImage.width,
      pixelHeight: processedImage.height,
    );
  }
}

int _normalizeRotation(int rotationDegrees) {
  return ((rotationDegrees % 360) + 360) % 360;
}

_EncodedDocumentImage? _rotateAndEncode(
  Uint8List sourceBytes,
  int rotationDegrees,
) {
  final sourceImage = img.decodeImage(sourceBytes);
  if (sourceImage == null) {
    return null;
  }

  final rotatedImage = img.copyRotate(sourceImage, angle: rotationDegrees);
  return _EncodedDocumentImage(
    bytes: Uint8List.fromList(img.encodeJpg(rotatedImage, quality: 95)),
    width: rotatedImage.width,
    height: rotatedImage.height,
  );
}

class _EncodedDocumentImage {
  const _EncodedDocumentImage({
    required this.bytes,
    required this.width,
    required this.height,
  });

  final Uint8List bytes;
  final int width;
  final int height;
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
