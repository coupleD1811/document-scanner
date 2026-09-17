import 'package:file_selector/file_selector.dart';

abstract interface class DocumentFilePicker {
  Future<XFile?> pickPdf();

  Future<List<XFile>> pickImages();
}

class SystemDocumentFilePicker implements DocumentFilePicker {
  const SystemDocumentFilePicker();

  @override
  Future<XFile?> pickPdf() {
    return openFile(
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'PDF',
          extensions: ['pdf'],
          mimeTypes: ['application/pdf'],
          uniformTypeIdentifiers: ['com.adobe.pdf'],
        ),
      ],
    );
  }

  @override
  Future<List<XFile>> pickImages() {
    return openFiles(
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'Images',
          extensions: ['jpg', 'jpeg', 'png'],
          mimeTypes: ['image/jpeg', 'image/png'],
          uniformTypeIdentifiers: ['public.jpeg', 'public.png'],
        ),
      ],
    );
  }
}
