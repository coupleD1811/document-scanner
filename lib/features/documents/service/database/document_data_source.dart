import '../../model/local_document.dart';
import '../../model/local_document_page.dart';

abstract interface class DocumentDataSource {
  Stream<List<LocalDocument>> watchDocuments();

  Future<List<LocalDocument>> getDocuments();

  Future<LocalDocument?> getDocument(String documentId);

  Future<List<LocalDocumentPage>> getDocumentPages(String documentId);

  Future<void> saveDocument(
    LocalDocument document,
    List<LocalDocumentPage> pages,
  );

  Future<void> renameDocument({
    required String documentId,
    required String name,
    required DateTime updatedAt,
  });

  Future<void> deleteDocument(String documentId);

  Future<void> close();
}
