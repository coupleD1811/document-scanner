import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../scan/model/scan_session.dart';
import '../model/local_document.dart';
import '../repository/document_repository.dart';
import '../service/scan_session_document_mapper.dart';

part 'document_save_event.dart';
part 'document_save_state.dart';

class DocumentSaveBloc extends Bloc<DocumentSaveEvent, DocumentSaveState> {
  DocumentSaveBloc({
    required DocumentRepository repository,
    ScanSessionDocumentMapper mapper = const ScanSessionDocumentMapper(),
  }) : _repository = repository,
       _mapper = mapper,
       super(const DocumentSaveInitial()) {
    on<DocumentSaveRequested>(_onSaveRequested);
  }

  final DocumentRepository _repository;
  final ScanSessionDocumentMapper _mapper;

  Future<void> _onSaveRequested(
    DocumentSaveRequested event,
    Emitter<DocumentSaveState> emit,
  ) async {
    if (state is DocumentSaveInProgress) {
      return;
    }

    emit(const DocumentSaveInProgress());
    try {
      final draft = _mapper.map(session: event.session, name: event.name);
      final document = await _repository.saveDocument(draft);
      emit(DocumentSaveSuccess(document));
    } on ScanSessionDocumentMappingException catch (error) {
      final failure = switch (error.failure) {
        ScanSessionDocumentMappingFailure.pageNotReady =>
          DocumentSaveFailureReason.pageNotReady,
        _ => DocumentSaveFailureReason.invalidInput,
      };
      emit(DocumentSaveFailure(failure));
    } on Object {
      emit(const DocumentSaveFailure(DocumentSaveFailureReason.storage));
    }
  }
}
