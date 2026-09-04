import 'package:document_scan/document_scan.dart' as document_scan;
import 'package:flutter/services.dart';

import '../model/document_corners.dart';
import '../model/normalized_point.dart';

enum DocumentEdgeDetectionFailure { unavailable, detectionFailed }

class DocumentEdgeDetectionException implements Exception {
  const DocumentEdgeDetectionException(this.failure, [this.cause]);

  final DocumentEdgeDetectionFailure failure;
  final Object? cause;
}

abstract interface class DocumentEdgeDetector {
  Future<DocumentCorners?> detect(String normalizedImagePath);
}

class NativeDocumentEdgeDetector implements DocumentEdgeDetector {
  NativeDocumentEdgeDetector({document_scan.DocumentDetector? detector})
    : _detector = detector ?? document_scan.DocumentDetector();

  final document_scan.DocumentDetector _detector;

  @override
  Future<DocumentCorners?> detect(String normalizedImagePath) async {
    try {
      final result = await _detector.detect(
        document_scan.ScanInput.file(normalizedImagePath),
        sensitivity: document_scan.DetectionSensitivity.lenient,
      );
      return result == null ? null : mapDetectedDocumentCorners(result);
    } on MissingPluginException catch (error) {
      throw DocumentEdgeDetectionException(
        DocumentEdgeDetectionFailure.unavailable,
        error,
      );
    } on PlatformException catch (error) {
      throw DocumentEdgeDetectionException(
        DocumentEdgeDetectionFailure.detectionFailed,
        error,
      );
    } on Object catch (error) {
      throw DocumentEdgeDetectionException(
        DocumentEdgeDetectionFailure.detectionFailed,
        error,
      );
    }
  }
}

DocumentCorners mapDetectedDocumentCorners(
  document_scan.DocumentCorners corners,
) {
  return DocumentCorners(
    topLeft: NormalizedPoint(
      x: corners.topLeft.x.clamp(0.0, 1.0),
      y: corners.topLeft.y.clamp(0.0, 1.0),
    ),
    topRight: NormalizedPoint(
      x: corners.topRight.x.clamp(0.0, 1.0),
      y: corners.topRight.y.clamp(0.0, 1.0),
    ),
    bottomRight: NormalizedPoint(
      x: corners.bottomRight.x.clamp(0.0, 1.0),
      y: corners.bottomRight.y.clamp(0.0, 1.0),
    ),
    bottomLeft: NormalizedPoint(
      x: corners.bottomLeft.x.clamp(0.0, 1.0),
      y: corners.bottomLeft.y.clamp(0.0, 1.0),
    ),
    source: DocumentCornersSource.detected,
    confidence: corners.confidence,
  );
}
