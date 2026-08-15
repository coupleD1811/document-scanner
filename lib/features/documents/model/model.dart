enum DocumentType { scan, pdf }

class DocumentItem {
  const DocumentItem({
    required this.id,
    required this.name,
    required this.type,
    required this.updatedAt,
    required this.pageCount,
    required this.sizeInBytes,
    this.hasOcrText = false,
  });

  final String id;
  final String name;
  final DocumentType type;
  final DateTime updatedAt;
  final int pageCount;
  final int sizeInBytes;
  final bool hasOcrText;
}
