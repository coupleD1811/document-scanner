import 'package:equatable/equatable.dart';

class NormalizedPoint extends Equatable {
  const NormalizedPoint({required this.x, required this.y})
    : assert(x >= 0 && x <= 1),
      assert(y >= 0 && y <= 1);

  final double x;
  final double y;

  @override
  List<Object?> get props => [x, y];
}
