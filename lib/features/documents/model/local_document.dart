import 'package:equatable/equatable.dart';

import 'ocr_status.dart';
import 'sync_status.dart';

class LocalDocument extends Equatable {
  LocalDocument({
    required this.id,
    required this.name,
    required this.pdfPath,
    required this.thumbnailPath,
    required this.pageCount,
    required this.sizeInBytes,
    required this.createdAt,
    required this.updatedAt,
    this.ocrStatus = DocumentOcrStatus.notRequested,
    this.syncStatus = DocumentSyncStatus.localOnly,
  }) : assert(id.isNotEmpty),
       assert(name.isNotEmpty),
       assert(pdfPath.isNotEmpty),
       assert(thumbnailPath.isNotEmpty),
       assert(pageCount > 0),
       assert(sizeInBytes >= 0),
       assert(!updatedAt.isBefore(createdAt));

  final String id;
  final String name;
  final String pdfPath;
  final String thumbnailPath;
  final int pageCount;
  final int sizeInBytes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DocumentOcrStatus ocrStatus;
  final DocumentSyncStatus syncStatus;

  LocalDocument copyWith({
    String? id,
    String? name,
    String? pdfPath,
    String? thumbnailPath,
    int? pageCount,
    int? sizeInBytes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DocumentOcrStatus? ocrStatus,
    DocumentSyncStatus? syncStatus,
  }) {
    return LocalDocument(
      id: id ?? this.id,
      name: name ?? this.name,
      pdfPath: pdfPath ?? this.pdfPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      pageCount: pageCount ?? this.pageCount,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ocrStatus: ocrStatus ?? this.ocrStatus,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    pdfPath,
    thumbnailPath,
    pageCount,
    sizeInBytes,
    createdAt,
    updatedAt,
    ocrStatus,
    syncStatus,
  ];
}
