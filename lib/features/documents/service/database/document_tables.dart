import 'package:drift/drift.dart';

@TableIndex(name: 'stored_documents_updated_at', columns: {#updatedAt})
class StoredDocuments extends Table {
  TextColumn get id => text().withLength(min: 1)();
  TextColumn get name => text().withLength(min: 1)();
  TextColumn get pdfPath => text().withLength(min: 1)();
  TextColumn get thumbnailPath => text().withLength(min: 1)();
  IntColumn get pageCount => integer()();
  IntColumn get sizeInBytes => integer()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get ocrStatus => text()();
  TextColumn get syncStatus => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@TableIndex(name: 'stored_document_pages_document_id', columns: {#documentId})
class StoredDocumentPages extends Table {
  TextColumn get id => text().withLength(min: 1)();
  TextColumn get documentId =>
      text().references(StoredDocuments, #id, onDelete: KeyAction.cascade)();
  IntColumn get pageIndex => integer()();
  TextColumn get originalImagePath => text().withLength(min: 1)();
  TextColumn get normalizedImagePath => text().withLength(min: 1)();
  TextColumn get processedImagePath => text().withLength(min: 1)();
  IntColumn get originalPixelWidth => integer()();
  IntColumn get originalPixelHeight => integer()();
  IntColumn get processedPixelWidth => integer()();
  IntColumn get processedPixelHeight => integer()();
  RealColumn get topLeftX => real()();
  RealColumn get topLeftY => real()();
  RealColumn get topRightX => real()();
  RealColumn get topRightY => real()();
  RealColumn get bottomRightX => real()();
  RealColumn get bottomRightY => real()();
  RealColumn get bottomLeftX => real()();
  RealColumn get bottomLeftY => real()();
  TextColumn get cornersSource => text()();
  RealColumn get cornersConfidence => real().nullable()();
  IntColumn get rotation => integer()();
  TextColumn get filter => text()();
  IntColumn get brightness => integer()();
  IntColumn get contrast => integer()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {documentId, pageIndex},
  ];
}
