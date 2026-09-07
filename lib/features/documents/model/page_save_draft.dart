import 'package:equatable/equatable.dart';

import '../../scan/model/document_corners.dart';
import '../../scan/model/scan_filter.dart';

class DocumentPageSaveDraft extends Equatable {
  DocumentPageSaveDraft({
    required this.sourcePageId,
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
  }) : assert(sourcePageId.isNotEmpty),
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
       assert(contrast >= -100 && contrast <= 100);

  final String sourcePageId;
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

  @override
  List<Object?> get props => [
    sourcePageId,
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
  ];
}
