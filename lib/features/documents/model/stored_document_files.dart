import 'package:equatable/equatable.dart';

class StoredDocumentFiles extends Equatable {
  StoredDocumentFiles({
    required this.documentId,
    required this.directoryPath,
    required this.pdfPath,
    required this.thumbnailPath,
    required List<StoredDocumentPageFiles> pages,
  }) : pages = List.unmodifiable(pages);

  final String documentId;
  final String directoryPath;
  final String pdfPath;
  final String thumbnailPath;
  final List<StoredDocumentPageFiles> pages;

  @override
  List<Object?> get props => [
    documentId,
    directoryPath,
    pdfPath,
    thumbnailPath,
    pages,
  ];
}

class StoredDocumentPageFiles extends Equatable {
  const StoredDocumentPageFiles({
    required this.sourcePageId,
    required this.pageIndex,
    required this.originalImagePath,
    required this.normalizedImagePath,
    required this.processedImagePath,
  });

  final String sourcePageId;
  final int pageIndex;
  final String originalImagePath;
  final String normalizedImagePath;
  final String processedImagePath;

  @override
  List<Object?> get props => [
    sourcePageId,
    pageIndex,
    originalImagePath,
    normalizedImagePath,
    processedImagePath,
  ];
}
