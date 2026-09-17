import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/document_repository.dart';
import '../service/document_import_service.dart';
import 'document_import_event.dart';
import 'document_import_state.dart';

class DocumentImportBloc
    extends Bloc<DocumentImportEvent, DocumentImportState> {
  DocumentImportBloc({required DocumentRepository repository})
    : _repository = repository,
      super(const DocumentImportInitial()) {
    on<DocumentImagesImportRequested>(_onImagesImportRequested);
    on<DocumentPdfImportRequested>(_onPdfImportRequested);
  }

  final DocumentRepository _repository;

  Future<void> _onImagesImportRequested(
    DocumentImagesImportRequested event,
    Emitter<DocumentImportState> emit,
  ) async {
    emit(const DocumentImportInProgress(DocumentImportType.images));
    try {
      final document = await _repository.importImages(
        sourcePaths: event.sourcePaths,
        name: event.name,
      );
      emit(DocumentImportSuccess(document, DocumentImportType.images));
    } on DocumentImportException catch (error) {
      emit(DocumentImportFailure(DocumentImportType.images, error.reason));
    } on Object {
      emit(
        const DocumentImportFailure(
          DocumentImportType.images,
          DocumentImportFailureReason.sourceUnavailable,
        ),
      );
    }
  }

  Future<void> _onPdfImportRequested(
    DocumentPdfImportRequested event,
    Emitter<DocumentImportState> emit,
  ) async {
    emit(const DocumentImportInProgress(DocumentImportType.pdf));
    try {
      final document = await _repository.importPdf(
        sourcePath: event.sourcePath,
        name: event.name,
      );
      emit(DocumentImportSuccess(document, DocumentImportType.pdf));
    } on DocumentImportException catch (error) {
      emit(DocumentImportFailure(DocumentImportType.pdf, error.reason));
    } on Object {
      emit(
        const DocumentImportFailure(
          DocumentImportType.pdf,
          DocumentImportFailureReason.invalidPdf,
        ),
      );
    }
  }
}
