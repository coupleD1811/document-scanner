import 'package:equatable/equatable.dart';

sealed class DocumentImportEvent extends Equatable {
  const DocumentImportEvent();

  @override
  List<Object?> get props => const [];
}

class DocumentImagesImportRequested extends DocumentImportEvent {
  const DocumentImagesImportRequested({
    required this.sourcePaths,
    required this.name,
  });

  final List<String> sourcePaths;
  final String name;

  @override
  List<Object?> get props => [sourcePaths, name];
}

class DocumentPdfImportRequested extends DocumentImportEvent {
  const DocumentPdfImportRequested({
    required this.sourcePath,
    required this.name,
  });

  final String sourcePath;
  final String name;

  @override
  List<Object?> get props => [sourcePath, name];
}
