import 'package:file_selector/file_selector.dart';

abstract interface class DocumentFilePicker {
  Future<XFile?> pickPdf();
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
}
