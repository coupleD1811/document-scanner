import 'package:equatable/equatable.dart';

import 'normalized_point.dart';

enum DocumentCornersSource { fullImage, detected, manual }

class DocumentCorners extends Equatable {
  const DocumentCorners({
    required this.topLeft,
    required this.topRight,
    required this.bottomRight,
    required this.bottomLeft,
    required this.source,
    this.confidence,
  });

  static const fullImage = DocumentCorners(
    topLeft: NormalizedPoint(x: 0, y: 0),
    topRight: NormalizedPoint(x: 1, y: 0),
    bottomRight: NormalizedPoint(x: 1, y: 1),
    bottomLeft: NormalizedPoint(x: 0, y: 1),
    source: DocumentCornersSource.fullImage,
  );

  final NormalizedPoint topLeft;
  final NormalizedPoint topRight;
  final NormalizedPoint bottomRight;
  final NormalizedPoint bottomLeft;
  final DocumentCornersSource source;
  final double? confidence;

  List<NormalizedPoint> get points => [
    topLeft,
    topRight,
    bottomRight,
    bottomLeft,
  ];

  double get area {
    var sum = 0.0;
    for (var index = 0; index < points.length; index += 1) {
      final current = points[index];
      final next = points[(index + 1) % points.length];
      sum += current.x * next.y - next.x * current.y;
    }
    return sum.abs() / 2;
  }

  bool get isConvex {
    double? expectedSign;
    for (var index = 0; index < points.length; index += 1) {
      final first = points[index];
      final second = points[(index + 1) % points.length];
      final third = points[(index + 2) % points.length];
      final cross =
          (second.x - first.x) * (third.y - second.y) -
          (second.y - first.y) * (third.x - second.x);
      if (cross.abs() < 0.000001) {
        return false;
      }

      final sign = cross.sign;
      expectedSign ??= sign;
      if (sign != expectedSign) {
        return false;
      }
    }
    return true;
  }

  bool get isUsable => isConvex && area >= 0.01;

  DocumentCorners copyWith({
    NormalizedPoint? topLeft,
    NormalizedPoint? topRight,
    NormalizedPoint? bottomRight,
    NormalizedPoint? bottomLeft,
    DocumentCornersSource? source,
    double? confidence,
    bool clearConfidence = false,
  }) {
    return DocumentCorners(
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      bottomRight: bottomRight ?? this.bottomRight,
      bottomLeft: bottomLeft ?? this.bottomLeft,
      source: source ?? this.source,
      confidence: clearConfidence ? null : confidence ?? this.confidence,
    );
  }

  @override
  List<Object?> get props => [
    topLeft,
    topRight,
    bottomRight,
    bottomLeft,
    source,
    confidence,
  ];
}
