import 'dart:typed_data';

class ImportedPdfPreview {
  ImportedPdfPreview({
    required this.documentId,
    required this.pageCount,
    required this.thumbnailBytes,
    required this.thumbnailWidth,
    required this.thumbnailHeight,
  }) : assert(documentId.isNotEmpty),
       assert(pageCount > 0),
       assert(thumbnailBytes.isNotEmpty),
       assert(thumbnailWidth > 0),
       assert(thumbnailHeight > 0);

  final String documentId;
  final int pageCount;
  final Uint8List thumbnailBytes;
  final int thumbnailWidth;
  final int thumbnailHeight;
}
