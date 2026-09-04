import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../model/normalized_document_image.dart';

enum ImageNormalizationFailure {
  sourceNotFound,
  sourceReadFailed,
  unsupportedFormat,
  outputWriteFailed,
}

class ImageNormalizationException implements Exception {
  const ImageNormalizationException(this.failure);

  final ImageNormalizationFailure failure;
}

abstract interface class DocumentImageNormalizer {
  Future<NormalizedDocumentImage> normalize(String imagePath);
}

typedef NormalizedImagePathBuilder = String Function(String sourcePath);

class LocalDocumentImageNormalizer implements DocumentImageNormalizer {
  LocalDocumentImageNormalizer({NormalizedImagePathBuilder? outputPathBuilder})
    : _outputPathBuilder = outputPathBuilder ?? _defaultOutputPath;

  final NormalizedImagePathBuilder _outputPathBuilder;

  @override
  Future<NormalizedDocumentImage> normalize(String imagePath) async {
    final sourceFile = File(imagePath);
    if (!await sourceFile.exists()) {
      throw const ImageNormalizationException(
        ImageNormalizationFailure.sourceNotFound,
      );
    }

    late final Uint8List sourceBytes;
    try {
      sourceBytes = await sourceFile.readAsBytes();
    } on Object {
      throw const ImageNormalizationException(
        ImageNormalizationFailure.sourceReadFailed,
      );
    }

    late final _NormalizedImageData normalized;
    try {
      normalized = await Isolate.run(
        () => _decodeAndNormalizeImage(sourceBytes),
      );
    } on ImageNormalizationException {
      rethrow;
    } on Object {
      throw const ImageNormalizationException(
        ImageNormalizationFailure.unsupportedFormat,
      );
    }

    final outputPath = _outputPathBuilder(imagePath);
    try {
      await File(outputPath).writeAsBytes(normalized.bytes, flush: true);
    } on Object {
      throw const ImageNormalizationException(
        ImageNormalizationFailure.outputWriteFailed,
      );
    }

    return NormalizedDocumentImage(
      originalImagePath: imagePath,
      normalizedImagePath: outputPath,
      pixelWidth: normalized.width,
      pixelHeight: normalized.height,
    );
  }
}

_NormalizedImageData _decodeAndNormalizeImage(Uint8List sourceBytes) {
  final decoded = img.decodeImage(sourceBytes);
  if (decoded == null) {
    throw const ImageNormalizationException(
      ImageNormalizationFailure.unsupportedFormat,
    );
  }

  final normalized = img.bakeOrientation(decoded);
  normalized.exif.clear();
  final outputBytes = img.encodeJpg(normalized, quality: 95);

  return _NormalizedImageData(
    bytes: outputBytes,
    width: normalized.width,
    height: normalized.height,
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
  return '${basePath}_normalized_$timestamp.jpg';
}

class _NormalizedImageData {
  const _NormalizedImageData({
    required this.bytes,
    required this.width,
    required this.height,
  });

  final Uint8List bytes;
  final int width;
  final int height;
}
