import 'package:equatable/equatable.dart';

class DocumentExportResult extends Equatable {
  const DocumentExportResult({required this.pdfSizeInBytes});

  final int pdfSizeInBytes;

  @override
  List<Object?> get props => [pdfSizeInBytes];
}
