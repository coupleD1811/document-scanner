import 'package:equatable/equatable.dart';

import 'document_corners.dart';
import 'document_edge_detection_status.dart';

class NormalizedDocumentImage extends Equatable {
  const NormalizedDocumentImage({
    required this.originalImagePath,
    required this.normalizedImagePath,
    required this.pixelWidth,
    required this.pixelHeight,
    this.corners = DocumentCorners.fullImage,
    this.detectedCorners,
    this.edgeDetectionStatus = DocumentEdgeDetectionStatus.notStarted,
  }) : assert(pixelWidth > 0),
       assert(pixelHeight > 0),
       assert(
         edgeDetectionStatus != DocumentEdgeDetectionStatus.detected ||
             detectedCorners != null,
       );

  final String originalImagePath;
  final String normalizedImagePath;
  final int pixelWidth;
  final int pixelHeight;
  final DocumentCorners corners;
  final DocumentCorners? detectedCorners;
  final DocumentEdgeDetectionStatus edgeDetectionStatus;

  NormalizedDocumentImage copyWith({
    String? originalImagePath,
    String? normalizedImagePath,
    int? pixelWidth,
    int? pixelHeight,
    DocumentCorners? corners,
    DocumentCorners? detectedCorners,
    bool clearDetectedCorners = false,
    DocumentEdgeDetectionStatus? edgeDetectionStatus,
  }) {
    return NormalizedDocumentImage(
      originalImagePath: originalImagePath ?? this.originalImagePath,
      normalizedImagePath: normalizedImagePath ?? this.normalizedImagePath,
      pixelWidth: pixelWidth ?? this.pixelWidth,
      pixelHeight: pixelHeight ?? this.pixelHeight,
      corners: corners ?? this.corners,
      detectedCorners: clearDetectedCorners
          ? null
          : detectedCorners ?? this.detectedCorners,
      edgeDetectionStatus: edgeDetectionStatus ?? this.edgeDetectionStatus,
    );
  }

  @override
  List<Object?> get props => [
    originalImagePath,
    normalizedImagePath,
    pixelWidth,
    pixelHeight,
    corners,
    detectedCorners,
    edgeDetectionStatus,
  ];
}
