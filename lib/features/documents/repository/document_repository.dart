import '../model/local_document.dart';
import '../model/local_document_page.dart';
import '../model/save_draft.dart';

abstract interface class DocumentRepository {
  Future<LocalDocument> saveDocument(DocumentSaveDraft draft);

  Future<LocalDocument> importImages({
    required List<String> sourcePaths,
    required String name,
  });

  Future<LocalDocument> importPdf({
    required String sourcePath,
    required String name,
  });

  Stream<List<LocalDocument>> watchDocuments();

  Future<List<LocalDocument>> getDocuments();

  Future<LocalDocument?> getDocument(String documentId);

  Future<List<LocalDocumentPage>> getDocumentPages(String documentId);

  Future<void> renameDocument(String documentId, String name);

  Future<void> deleteDocument(String documentId);

  Future<void> close();
}
