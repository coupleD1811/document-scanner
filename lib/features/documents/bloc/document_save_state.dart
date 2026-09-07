part of 'document_save_bloc.dart';

enum DocumentSaveFailureReason { invalidInput, pageNotReady, storage }

sealed class DocumentSaveState extends Equatable {
  const DocumentSaveState();

  @override
  List<Object?> get props => [];
}

final class DocumentSaveInitial extends DocumentSaveState {
  const DocumentSaveInitial();
}

final class DocumentSaveInProgress extends DocumentSaveState {
  const DocumentSaveInProgress();
}

final class DocumentSaveSuccess extends DocumentSaveState {
  const DocumentSaveSuccess(this.document);

  final LocalDocument document;

  @override
  List<Object?> get props => [document];
}

final class DocumentSaveFailure extends DocumentSaveState {
  const DocumentSaveFailure(this.reason);

  final DocumentSaveFailureReason reason;

  @override
  List<Object?> get props => [reason];
}
