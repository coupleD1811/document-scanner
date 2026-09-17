import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/local_document.dart';
import '../repository/document_repository.dart';
import '../service/document_file_opener.dart';
import '../service/document_share_service.dart';

part 'document_action_event.dart';
part 'document_action_state.dart';

class DocumentActionBloc
    extends Bloc<DocumentActionEvent, DocumentActionState> {
  DocumentActionBloc({
    required DocumentRepository repository,
    DocumentFileOpener fileOpener = const SystemDocumentFileOpener(),
    DocumentShareService shareService = const SystemDocumentShareService(),
  }) : _repository = repository,
       _fileOpener = fileOpener,
       _shareService = shareService,
       super(const DocumentActionInitial()) {
    on<DocumentOpenRequested>(_onOpenRequested);
    on<DocumentRenameRequested>(_onRenameRequested);
    on<DocumentShareRequested>(_onShareRequested);
    on<DocumentDeleteRequested>(_onDeleteRequested);
  }

  final DocumentRepository _repository;
  final DocumentFileOpener _fileOpener;
  final DocumentShareService _shareService;

  Future<void> _onOpenRequested(
    DocumentOpenRequested event,
    Emitter<DocumentActionState> emit,
  ) async {
    await _run(
      action: DocumentAction.open,
      documentId: event.documentId,
      emit: emit,
      operation: (document) => _fileOpener.open(document),
    );
  }

  Future<void> _onRenameRequested(
    DocumentRenameRequested event,
    Emitter<DocumentActionState> emit,
  ) async {
    await _run(
      action: DocumentAction.rename,
      documentId: event.documentId,
      emit: emit,
      operation: (_) =>
          _repository.renameDocument(event.documentId, event.name),
      name: event.name,
    );
  }

  Future<void> _onShareRequested(
    DocumentShareRequested event,
    Emitter<DocumentActionState> emit,
  ) async {
    await _run(
      action: DocumentAction.share,
      documentId: event.documentId,
      emit: emit,
      operation: (document) => _shareService.share(document),
    );
  }

  Future<void> _onDeleteRequested(
    DocumentDeleteRequested event,
    Emitter<DocumentActionState> emit,
  ) async {
    await _run(
      action: DocumentAction.delete,
      documentId: event.documentId,
      emit: emit,
      operation: (_) => _repository.deleteDocument(event.documentId),
    );
  }

  Future<void> _run({
    required DocumentAction action,
    required String documentId,
    required Emitter<DocumentActionState> emit,
    required Future<void> Function(LocalDocument document) operation,
    String? name,
  }) async {
    if (state is DocumentActionInProgress) {
      return;
    }

    emit(DocumentActionInProgress(action: action, documentId: documentId));
    try {
      final document = await _repository.getDocument(documentId);
      if (document == null) {
        emit(
          DocumentActionFailure(
            action: action,
            documentId: documentId,
            reason: DocumentActionFailureReason.notFound,
          ),
        );
        return;
      }

      await operation(document);
      emit(
        DocumentActionSuccess(
          action: action,
          documentId: documentId,
          documentName: name ?? document.name,
        ),
      );
    } on ArgumentError {
      emit(
        DocumentActionFailure(
          action: action,
          documentId: documentId,
          reason: DocumentActionFailureReason.invalidName,
        ),
      );
    } on FileSystemException {
      emit(
        DocumentActionFailure(
          action: action,
          documentId: documentId,
          reason: DocumentActionFailureReason.fileUnavailable,
        ),
      );
    } on Object {
      emit(
        DocumentActionFailure(
          action: action,
          documentId: documentId,
          reason: DocumentActionFailureReason.unexpected,
        ),
      );
    }
  }
}
