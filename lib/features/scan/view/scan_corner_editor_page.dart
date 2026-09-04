import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../l10n/l10n.dart';
import '../model/document_corners.dart';
import '../model/document_page.dart';
import '../model/normalized_point.dart';
import 'widgets/document_corners_painter.dart';

class ScanCornerEditorPage extends StatefulWidget {
  const ScanCornerEditorPage({required this.page, super.key});

  final DocumentPage page;

  @override
  State<ScanCornerEditorPage> createState() => _ScanCornerEditorPageState();
}

class _ScanCornerEditorPageState extends State<ScanCornerEditorPage> {
  late DocumentCorners _corners;

  DocumentCorners get _resetCorners =>
      widget.page.detectedCorners ?? DocumentCorners.fullImage;

  @override
  void initState() {
    super.initState();
    _corners = widget.page.corners;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final isValid = _corners.isUsable;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.scanCornerEditorTitle),
        leading: IconButton(
          tooltip: t.scanEditorCancel,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LucideIcons.x),
        ),
        actions: [
          TextButton.icon(
            key: const ValueKey('scan-corners-reset'),
            onPressed: () => setState(() => _corners = _resetCorners),
            icon: const Icon(LucideIcons.rotateCcw, size: 18),
            label: Text(t.scanCornerReset),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _CornerEditorCanvas(
                  page: widget.page,
                  corners: _corners,
                  onChanged: (corners) => setState(() => _corners = corners),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isValid ? LucideIcons.move : LucideIcons.triangleAlert,
                    size: 18,
                    color: isValid
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isValid
                          ? t.scanCornerEditorHint
                          : t.scanCornerInvalidMessage,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isValid
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                key: const ValueKey('scan-corners-save'),
                onPressed: isValid
                    ? () => Navigator.of(context).pop(_corners)
                    : null,
                icon: const Icon(LucideIcons.check, size: 19),
                label: Text(t.scanCornerSave),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CornerEditorCanvas extends StatelessWidget {
  const _CornerEditorCanvas({
    required this.page,
    required this.corners,
    required this.onChanged,
  });

  static const _handleTouchSize = 48.0;

  final DocumentPage page;
  final DocumentCorners corners;
  final ValueChanged<DocumentCorners> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: ColoredBox(
        color: Colors.black,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final canvasSize = Size(
              constraints.maxWidth,
              constraints.maxHeight,
            );
            final imageRect = _fittedImageRect(canvasSize, page);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fromRect(
                  rect: imageRect,
                  child: Image.file(
                    File(page.normalizedImagePath),
                    fit: BoxFit.fill,
                    errorBuilder: (_, _, _) => ColoredBox(
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(
                        LucideIcons.imageOff,
                        color: colorScheme.onSurfaceVariant,
                        size: 48,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: DocumentCornersPainter(
                        corners: corners,
                        imageRect: imageRect,
                        lineColor: colorScheme.secondary,
                        dimOutside: true,
                      ),
                    ),
                  ),
                ),
                for (final corner in _CornerPosition.values)
                  _buildHandle(context, corner, imageRect),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHandle(
    BuildContext context,
    _CornerPosition position,
    Rect imageRect,
  ) {
    final point = _pointFor(position);
    final center = Offset(
      imageRect.left + point.x * imageRect.width,
      imageRect.top + point.y * imageRect.height,
    );
    var dragPoint = point;

    return Positioned(
      left: center.dx - _handleTouchSize / 2,
      top: center.dy - _handleTouchSize / 2,
      width: _handleTouchSize,
      height: _handleTouchSize,
      child: Semantics(
        label: _semanticLabel(context, position),
        child: GestureDetector(
          key: ValueKey('scan-corner-${position.name}'),
          behavior: HitTestBehavior.opaque,
          onPanUpdate: (details) {
            dragPoint = NormalizedPoint(
              x: (dragPoint.x + details.delta.dx / imageRect.width).clamp(
                0.0,
                1.0,
              ),
              y: (dragPoint.y + details.delta.dy / imageRect.height).clamp(
                0.0,
                1.0,
              ),
            );
            onChanged(_replacePoint(position, dragPoint));
          },
          child: Center(
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: const [
                  BoxShadow(color: Colors.black45, blurRadius: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  NormalizedPoint _pointFor(_CornerPosition position) {
    return switch (position) {
      _CornerPosition.topLeft => corners.topLeft,
      _CornerPosition.topRight => corners.topRight,
      _CornerPosition.bottomRight => corners.bottomRight,
      _CornerPosition.bottomLeft => corners.bottomLeft,
    };
  }

  DocumentCorners _replacePoint(
    _CornerPosition position,
    NormalizedPoint point,
  ) {
    return corners.copyWith(
      topLeft: position == _CornerPosition.topLeft ? point : null,
      topRight: position == _CornerPosition.topRight ? point : null,
      bottomRight: position == _CornerPosition.bottomRight ? point : null,
      bottomLeft: position == _CornerPosition.bottomLeft ? point : null,
      source: DocumentCornersSource.manual,
      clearConfidence: true,
    );
  }

  String _semanticLabel(BuildContext context, _CornerPosition position) {
    final t = context.l10n;
    return switch (position) {
      _CornerPosition.topLeft => t.scanCornerTopLeft,
      _CornerPosition.topRight => t.scanCornerTopRight,
      _CornerPosition.bottomRight => t.scanCornerBottomRight,
      _CornerPosition.bottomLeft => t.scanCornerBottomLeft,
    };
  }
}

Rect _fittedImageRect(Size canvasSize, DocumentPage page) {
  const inset = _CornerEditorCanvas._handleTouchSize / 2;
  final availableWidth = math.max(1.0, canvasSize.width - inset * 2);
  final availableHeight = math.max(1.0, canvasSize.height - inset * 2);
  final scale = math.min(
    availableWidth / page.pixelWidth,
    availableHeight / page.pixelHeight,
  );
  final imageSize = Size(page.pixelWidth * scale, page.pixelHeight * scale);
  return Rect.fromLTWH(
    (canvasSize.width - imageSize.width) / 2,
    (canvasSize.height - imageSize.height) / 2,
    imageSize.width,
    imageSize.height,
  );
}

enum _CornerPosition { topLeft, topRight, bottomRight, bottomLeft }
