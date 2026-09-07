import 'package:equatable/equatable.dart';

import '../../scan/model/document_corners.dart';
import '../../scan/model/scan_filter.dart';

class LocalDocumentPage extends Equatable {
  LocalDocumentPage({
    required this.id,
    required this.documentId,
    required this.pageIndex,
    required this.originalImagePath,
    required this.normalizedImagePath,
    required this.processedImagePath,
    required this.originalPixelWidth,
    required this.originalPixelHeight,
    required this.processedPixelWidth,
    required this.processedPixelHeight,
    required this.corners,
    required this.rotation,
    required this.filter,
    required this.brightness,
    required this.contrast,
    required this.createdAt,
    required this.updatedAt,
  }) : assert(id.isNotEmpty),
       assert(documentId.isNotEmpty),
       assert(pageIndex >= 0),
       assert(originalImagePath.isNotEmpty),
       assert(normalizedImagePath.isNotEmpty),
       assert(processedImagePath.isNotEmpty),
       assert(originalPixelWidth > 0),
       assert(originalPixelHeight > 0),
       assert(processedPixelWidth > 0),
       assert(processedPixelHeight > 0),
       assert(
         rotation == 0 || rotation == 90 || rotation == 180 || rotation == 270,
       ),
       assert(brightness >= -100 && brightness <= 100),
       assert(contrast >= -100 && contrast <= 100),
       assert(!updatedAt.isBefore(createdAt));

  final String id;
  final String documentId;
  final int pageIndex;
  final String originalImagePath;
  final String normalizedImagePath;
  final String processedImagePath;
  final int originalPixelWidth;
  final int originalPixelHeight;
  final int processedPixelWidth;
  final int processedPixelHeight;
  final DocumentCorners corners;
  final int rotation;
  final ScanFilter filter;
  final int brightness;
  final int contrast;
  final DateTime createdAt;
  final DateTime updatedAt;

  LocalDocumentPage copyWith({
    String? id,
    String? documentId,
    int? pageIndex,
    String? originalImagePath,
    String? normalizedImagePath,
    String? processedImagePath,
    int? originalPixelWidth,
    int? originalPixelHeight,
    int? processedPixelWidth,
    int? processedPixelHeight,
    DocumentCorners? corners,
    int? rotation,
    ScanFilter? filter,
    int? brightness,
    int? contrast,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LocalDocumentPage(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      pageIndex: pageIndex ?? this.pageIndex,
      originalImagePath: originalImagePath ?? this.originalImagePath,
      normalizedImagePath: normalizedImagePath ?? this.normalizedImagePath,
      processedImagePath: processedImagePath ?? this.processedImagePath,
      originalPixelWidth: originalPixelWidth ?? this.originalPixelWidth,
      originalPixelHeight: originalPixelHeight ?? this.originalPixelHeight,
      processedPixelWidth: processedPixelWidth ?? this.processedPixelWidth,
      processedPixelHeight: processedPixelHeight ?? this.processedPixelHeight,
      corners: corners ?? this.corners,
      rotation: rotation ?? this.rotation,
      filter: filter ?? this.filter,
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    documentId,
    pageIndex,
    originalImagePath,
    normalizedImagePath,
    processedImagePath,
    originalPixelWidth,
    originalPixelHeight,
    processedPixelWidth,
    processedPixelHeight,
    corners,
    rotation,
    filter,
    brightness,
    contrast,
    createdAt,
    updatedAt,
  ];
}
