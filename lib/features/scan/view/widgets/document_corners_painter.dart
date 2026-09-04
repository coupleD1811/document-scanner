import 'package:flutter/material.dart';

import '../../model/document_corners.dart';

class DocumentCornersPainter extends CustomPainter {
  const DocumentCornersPainter({
    required this.corners,
    required this.lineColor,
    this.imageRect,
    this.dimOutside = false,
  });

  final DocumentCorners corners;
  final Color lineColor;
  final Rect? imageRect;
  final bool dimOutside;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = imageRect ?? (Offset.zero & size);
    final points = corners.points
        .map(
          (point) => Offset(
            rect.left + point.x * rect.width,
            rect.top + point.y * rect.height,
          ),
        )
        .toList(growable: false);
    final documentPath = Path()..addPolygon(points, true);

    if (dimOutside) {
      final shadePath = Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(rect)
        ..addPath(documentPath, Offset.zero);
      canvas.drawPath(
        shadePath,
        Paint()..color = Colors.black.withValues(alpha: 0.52),
      );
    }

    canvas.drawPath(
      documentPath,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(DocumentCornersPainter oldDelegate) {
    return corners != oldDelegate.corners ||
        lineColor != oldDelegate.lineColor ||
        imageRect != oldDelegate.imageRect ||
        dimOutside != oldDelegate.dimOutside;
  }
}
