import 'package:equatable/equatable.dart';

class ProcessedDocumentImage extends Equatable {
  const ProcessedDocumentImage({
    required this.imagePath,
    required this.pixelWidth,
    required this.pixelHeight,
  }) : assert(pixelWidth > 0),
       assert(pixelHeight > 0);

  final String imagePath;
  final int pixelWidth;
  final int pixelHeight;

  @override
  List<Object?> get props => [imagePath, pixelWidth, pixelHeight];
}
