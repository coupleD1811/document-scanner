import '../model/local_document.dart';
import '../model/local_document_page.dart';
import '../model/save_draft.dart';

abstract interface class DocumentRepository {
  Future<LocalDocument> saveDocument(DocumentSaveDraft draft);

  Stream<List<LocalDocument>> watchDocuments();

  Future<List<LocalDocument>> getDocuments();

  Future<List<LocalDocumentPage>> getDocumentPages(String documentId);

  Future<void> renameDocument(String documentId, String name);

  Future<void> deleteDocument(String documentId);

  Future<void> close();
}
