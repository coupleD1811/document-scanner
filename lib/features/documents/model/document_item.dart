import 'package:equatable/equatable.dart';

import 'local_document.dart';
import 'ocr_status.dart';

enum DocumentType { scan, pdf }

class DocumentItem extends Equatable {
  const DocumentItem({
    required this.id,
    required this.name,
    required this.type,
    required this.updatedAt,
    required this.pageCount,
    required this.sizeInBytes,
    this.thumbnailPath,
    this.hasOcrText = false,
  });

  factory DocumentItem.fromLocalDocument(LocalDocument document) {
    return DocumentItem(
      id: document.id,
      name: document.name,
      type: DocumentType.scan,
      updatedAt: document.updatedAt,
      pageCount: document.pageCount,
      sizeInBytes: document.sizeInBytes,
      thumbnailPath: document.thumbnailPath,
      hasOcrText: document.ocrStatus == DocumentOcrStatus.completed,
    );
  }

  final String id;
  final String name;
  final DocumentType type;
  final DateTime updatedAt;
  final int pageCount;
  final int sizeInBytes;
  final String? thumbnailPath;
  final bool hasOcrText;

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    updatedAt,
    pageCount,
    sizeInBytes,
    thumbnailPath,
    hasOcrText,
  ];
}
