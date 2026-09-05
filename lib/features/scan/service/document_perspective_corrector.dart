import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:document_scan/document_scan.dart' as document_scan;
import 'package:image/image.dart' as img;

import '../model/document_corners.dart';
import '../model/processed_document_image.dart';
import '../model/scan_filter.dart';

enum PerspectiveCorrectionFailure {
  sourceNotFound,
  invalidCorners,
  invalidRotation,
  invalidAdjustments,
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
    ScanFilter filter = ScanFilter.original,
    int brightness = 0,
    int contrast = 0,
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
    ScanFilter filter = ScanFilter.original,
    int brightness = 0,
    int contrast = 0,
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
    if (brightness < -100 ||
        brightness > 100 ||
        contrast < -100 ||
        contrast > 100) {
      throw const PerspectiveCorrectionException(
        PerspectiveCorrectionFailure.invalidAdjustments,
      );
    }
    final normalizedRotation = _normalizeRotation(rotationDegrees);
    final needsPostProcessing =
        normalizedRotation != 0 ||
        brightness != 0 ||
        contrast != 0 ||
        filter == ScanFilter.blackAndWhite;

    late final document_scan.ScannedDocument? result;
    try {
      result = await _processor.crop(
        document_scan.ScanInput.file(normalizedImagePath),
        _mapCorners(corners),
        filter: _mapFilter(filter),
        output: !needsPostProcessing
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
    if (!needsPostProcessing) {
      processedImage = _EncodedDocumentImage(
        bytes: result.bytes,
        width: result.width,
        height: result.height,
      );
    } else {
      try {
        final rotatedImage = await Isolate.run(
          () => _transformAndEncode(
            result!.bytes,
            normalizedRotation,
            brightness,
            contrast,
            filter == ScanFilter.blackAndWhite,
          ),
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

document_scan.ScanFilter _mapFilter(ScanFilter filter) {
  return switch (filter) {
    ScanFilter.original => document_scan.ScanFilter.none,
    ScanFilter.color => document_scan.ScanFilter.sharpen,
    ScanFilter.grayscale => document_scan.ScanFilter.grayscale,
    ScanFilter.blackAndWhite => document_scan.ScanFilter.grayscale,
  };
}

int _normalizeRotation(int rotationDegrees) {
  return ((rotationDegrees % 360) + 360) % 360;
}

_EncodedDocumentImage? _transformAndEncode(
  Uint8List sourceBytes,
  int rotationDegrees,
  int brightness,
  int contrast,
  bool applyBlackAndWhite,
) {
  var transformedImage = img.decodeImage(sourceBytes);
  if (transformedImage == null) {
    return null;
  }

  if (brightness != 0 || contrast != 0) {
    transformedImage = img.adjustColor(
      transformedImage,
      brightness: 1 + brightness / 100,
      contrast: 1 + contrast / 100,
    );
  }
  if (applyBlackAndWhite) {
    transformedImage = _applyOtsuThreshold(transformedImage);
  }
  if (rotationDegrees != 0) {
    transformedImage = img.copyRotate(transformedImage, angle: rotationDegrees);
  }

  return _EncodedDocumentImage(
    bytes: Uint8List.fromList(img.encodeJpg(transformedImage, quality: 95)),
    width: transformedImage.width,
    height: transformedImage.height,
  );
}

img.Image _applyOtsuThreshold(img.Image sourceImage) {
  final histogram = List<int>.filled(256, 0);
  for (final pixel in sourceImage) {
    final luminance = (0.3 * pixel.r + 0.59 * pixel.g + 0.11 * pixel.b)
        .round()
        .clamp(0, 255);
    histogram[luminance] += 1;
  }

  final total = sourceImage.width * sourceImage.height;
  var weightedTotal = 0.0;
  for (var value = 0; value < histogram.length; value += 1) {
    weightedTotal += value * histogram[value];
  }

  var weightedBackground = 0.0;
  var backgroundCount = 0;
  var bestVariance = -1.0;
  var threshold = 127;
  for (var value = 0; value < histogram.length; value += 1) {
    backgroundCount += histogram[value];
    if (backgroundCount == 0) {
      continue;
    }
    final foregroundCount = total - backgroundCount;
    if (foregroundCount == 0) {
      break;
    }

    weightedBackground += value * histogram[value];
    final backgroundMean = weightedBackground / backgroundCount;
    final foregroundMean =
        (weightedTotal - weightedBackground) / foregroundCount;
    final difference = backgroundMean - foregroundMean;
    final variance =
        backgroundCount * foregroundCount * difference * difference;
    if (variance > bestVariance) {
      bestVariance = variance;
      threshold = value;
    }
  }

  return img.luminanceThreshold(
    sourceImage,
    threshold: (threshold + 0.5) / 255,
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
