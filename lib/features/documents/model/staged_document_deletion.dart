import 'package:equatable/equatable.dart';

class StagedDocumentDeletion extends Equatable {
  const StagedDocumentDeletion({
    required this.originalDirectoryPath,
    required this.stagedDirectoryPath,
  });

  final String originalDirectoryPath;
  final String stagedDirectoryPath;

  @override
  List<Object?> get props => [originalDirectoryPath, stagedDirectoryPath];
}
