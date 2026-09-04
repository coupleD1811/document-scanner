import 'package:equatable/equatable.dart';

import 'scan_filter.dart';

class DocumentPage extends Equatable {
  const DocumentPage({
    required this.id,
    required this.originalImagePath,
    required this.pageIndex,
    required this.createdAt,
    this.processedImagePath,
    this.rotation = 0,
    this.filter = ScanFilter.original,
  });

  final String id;
  final String originalImagePath;
  final String? processedImagePath;
  final int pageIndex;
  final int rotation;
  final ScanFilter filter;
  final DateTime createdAt;

  String get displayImagePath => processedImagePath ?? originalImagePath;

  DocumentPage copyWith({
    String? id,
    String? originalImagePath,
    String? processedImagePath,
    bool clearProcessedImagePath = false,
    int? pageIndex,
    int? rotation,
    ScanFilter? filter,
    DateTime? createdAt,
  }) {
    return DocumentPage(
      id: id ?? this.id,
      originalImagePath: originalImagePath ?? this.originalImagePath,
      processedImagePath: clearProcessedImagePath
          ? null
          : processedImagePath ?? this.processedImagePath,
      pageIndex: pageIndex ?? this.pageIndex,
      rotation: rotation ?? this.rotation,
      filter: filter ?? this.filter,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    originalImagePath,
    processedImagePath,
    pageIndex,
    rotation,
    filter,
    createdAt,
  ];
}
