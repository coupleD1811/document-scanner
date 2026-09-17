import 'package:equatable/equatable.dart';

import '../model/local_document.dart';
import '../service/document_import_service.dart';

enum DocumentImportType { images, pdf }

sealed class DocumentImportState extends Equatable {
  const DocumentImportState();

  @override
  List<Object?> get props => const [];
}

class DocumentImportInitial extends DocumentImportState {
  const DocumentImportInitial();
}

class DocumentImportInProgress extends DocumentImportState {
  const DocumentImportInProgress(this.type);

  final DocumentImportType type;

  @override
  List<Object?> get props => [type];
}

class DocumentImportSuccess extends DocumentImportState {
  const DocumentImportSuccess(this.document, this.type);

  final LocalDocument document;
  final DocumentImportType type;

  @override
  List<Object?> get props => [document, type];
}

class DocumentImportFailure extends DocumentImportState {
  const DocumentImportFailure(this.type, this.reason);

  final DocumentImportType type;
  final DocumentImportFailureReason reason;

  @override
  List<Object?> get props => [type, reason];
}
