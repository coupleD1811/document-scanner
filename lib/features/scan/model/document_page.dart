import 'package:equatable/equatable.dart';

import 'document_corners.dart';
import 'document_edge_detection_status.dart';
import 'document_processing_status.dart';
import 'scan_filter.dart';

class DocumentPage extends Equatable {
  const DocumentPage({
    required this.id,
    required this.originalImagePath,
    required this.normalizedImagePath,
    required this.pixelWidth,
    required this.pixelHeight,
    required this.pageIndex,
    required this.createdAt,
    this.processedImagePath,
    this.processedPixelWidth,
    this.processedPixelHeight,
    this.corners = DocumentCorners.fullImage,
    this.detectedCorners,
    this.edgeDetectionStatus = DocumentEdgeDetectionStatus.notStarted,
    this.processingStatus = DocumentProcessingStatus.notStarted,
    this.rotation = 0,
    this.filter = ScanFilter.original,
  }) : assert(
         processedImagePath == null ||
             (processedPixelWidth != null && processedPixelHeight != null),
       );

  final String id;
  final String originalImagePath;
  final String normalizedImagePath;
  final String? processedImagePath;
  final int? processedPixelWidth;
  final int? processedPixelHeight;
  final int pixelWidth;
  final int pixelHeight;
  final int pageIndex;
  final DocumentCorners corners;
  final DocumentCorners? detectedCorners;
  final DocumentEdgeDetectionStatus edgeDetectionStatus;
  final DocumentProcessingStatus processingStatus;
  final int rotation;
  final ScanFilter filter;
  final DateTime createdAt;

  String get displayImagePath => processedImagePath ?? normalizedImagePath;
  int get displayPixelWidth => processedPixelWidth ?? pixelWidth;
  int get displayPixelHeight => processedPixelHeight ?? pixelHeight;

  DocumentPage copyWith({
    String? id,
    String? originalImagePath,
    String? normalizedImagePath,
    String? processedImagePath,
    bool clearProcessedImagePath = false,
    int? processedPixelWidth,
    int? processedPixelHeight,
    int? pixelWidth,
    int? pixelHeight,
    int? pageIndex,
    DocumentCorners? corners,
    DocumentCorners? detectedCorners,
    bool clearDetectedCorners = false,
    DocumentEdgeDetectionStatus? edgeDetectionStatus,
    DocumentProcessingStatus? processingStatus,
    int? rotation,
    ScanFilter? filter,
    DateTime? createdAt,
  }) {
    return DocumentPage(
      id: id ?? this.id,
      originalImagePath: originalImagePath ?? this.originalImagePath,
      normalizedImagePath: normalizedImagePath ?? this.normalizedImagePath,
      processedImagePath: clearProcessedImagePath
          ? null
          : processedImagePath ?? this.processedImagePath,
      processedPixelWidth: clearProcessedImagePath
          ? null
          : processedPixelWidth ?? this.processedPixelWidth,
      processedPixelHeight: clearProcessedImagePath
          ? null
          : processedPixelHeight ?? this.processedPixelHeight,
      pixelWidth: pixelWidth ?? this.pixelWidth,
      pixelHeight: pixelHeight ?? this.pixelHeight,
      pageIndex: pageIndex ?? this.pageIndex,
      corners: corners ?? this.corners,
      detectedCorners: clearDetectedCorners
          ? null
          : detectedCorners ?? this.detectedCorners,
      edgeDetectionStatus: edgeDetectionStatus ?? this.edgeDetectionStatus,
      processingStatus: processingStatus ?? this.processingStatus,
      rotation: rotation ?? this.rotation,
      filter: filter ?? this.filter,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    originalImagePath,
    normalizedImagePath,
    processedImagePath,
    processedPixelWidth,
    processedPixelHeight,
    pixelWidth,
    pixelHeight,
    pageIndex,
    corners,
    detectedCorners,
    edgeDetectionStatus,
    processingStatus,
    rotation,
    filter,
    createdAt,
  ];
}
