class StoredImportedPdfFiles {
  const StoredImportedPdfFiles({
    required this.documentId,
    required this.directoryPath,
    required this.pdfPath,
    required this.thumbnailPath,
  });

  final String documentId;
  final String directoryPath;
  final String pdfPath;
  final String thumbnailPath;
}
