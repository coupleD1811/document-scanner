import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/theme/scanly_icons.dart';
import '../../../l10n/l10n.dart';
import '../bloc/scan_session_bloc.dart';
import '../model/document_corners.dart';
import '../model/document_edge_detection_status.dart';
import '../model/document_page.dart';
import '../model/normalized_document_image.dart';
import 'scan_camera_page.dart';
import 'scan_corner_editor_page.dart';
import 'widgets/document_corners_painter.dart';

class ScanEditorPage extends StatefulWidget {
  const ScanEditorPage({super.key});

  @override
  State<ScanEditorPage> createState() => _ScanEditorPageState();
}

class _ScanEditorPageState extends State<ScanEditorPage> {
  bool _isShowingDiscardDialog = false;
  bool _canPop = false;

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          unawaited(_cancelSession());
        }
      },
      child: BlocBuilder<ScanSessionBloc, ScanSessionState>(
        builder: (context, state) {
          final editingState = state is ScanSessionEditing ? state : null;

          return Scaffold(
            appBar: AppBar(
              title: Text(t.scanEditorTitle),
              leading: IconButton(
                tooltip: t.scanEditorCancel,
                onPressed: _cancelSession,
                icon: const Icon(LucideIcons.x),
              ),
              actions: [
                IconButton(
                  key: const ValueKey('scan-editor-delete-page'),
                  tooltip: t.scanEditorDeletePage,
                  onPressed: editingState == null
                      ? null
                      : () => context.read<ScanSessionBloc>().add(
                          ScanSessionPageRemoved(editingState.selectedPage.id),
                        ),
                  icon: const Icon(LucideIcons.trash2),
                ),
              ],
            ),
            body: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: editingState == null
                    ? _EmptyEditor(onAddPage: _addPage)
                    : _EditorContent(
                        state: editingState,
                        onAddPage: _addPage,
                        onCancel: _cancelSession,
                        onContinue: _continueToPdf,
                        onAdjustCorners: _adjustCorners,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _adjustCorners(DocumentPage page) async {
    final corners = await Navigator.of(context).push<DocumentCorners>(
      MaterialPageRoute(builder: (_) => ScanCornerEditorPage(page: page)),
    );
    if (!mounted || corners == null) {
      return;
    }

    context.read<ScanSessionBloc>().add(
      ScanSessionPageCornersUpdated(pageId: page.id, corners: corners),
    );
  }

  Future<void> _addPage() async {
    final image = await Navigator.of(context).push<NormalizedDocumentImage>(
      MaterialPageRoute(builder: (_) => const ScanCameraPage()),
    );
    if (!mounted || image == null) {
      return;
    }

    context.read<ScanSessionBloc>().add(ScanSessionPageAdded(image));
  }

  Future<void> _cancelSession() async {
    if (_isShowingDiscardDialog) {
      return;
    }

    final hasPages = context.read<ScanSessionBloc>().state.session != null;
    if (!hasPages) {
      context.read<ScanSessionBloc>().add(const ScanSessionCleared());
      _leaveEditor();
      return;
    }

    _isShowingDiscardDialog = true;
    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.scanEditorDiscardTitle),
        content: Text(context.l10n.scanEditorDiscardMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.scanEditorKeepEditing),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              context.l10n.scanEditorDiscard,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    _isShowingDiscardDialog = false;

    if (!mounted || shouldDiscard != true) {
      return;
    }
    context.read<ScanSessionBloc>().add(const ScanSessionCleared());
    _leaveEditor();
  }

  void _leaveEditor() {
    setState(() => _canPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  void _continueToPdf() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.scanPdfComingSoon)));
  }
}

class _EditorContent extends StatelessWidget {
  const _EditorContent({
    required this.state,
    required this.onAddPage,
    required this.onCancel,
    required this.onContinue,
    required this.onAdjustCorners,
  });

  final ScanSessionEditing state;
  final VoidCallback onAddPage;
  final VoidCallback onCancel;
  final VoidCallback onContinue;
  final ValueChanged<DocumentPage> onAdjustCorners;

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final pages = state.session.pages;
    final selectedPage = state.selectedPage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _PagePreview(page: selectedPage)),
        const SizedBox(height: 8),
        _EdgeDetectionControl(
          page: selectedPage,
          onPressed: () => onAdjustCorners(selectedPage),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                t.scanEditorPageProgress(
                  state.selectedPageIndex + 1,
                  pages.length,
                ),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const Icon(LucideIcons.grip, size: 17),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                t.scanEditorReorderHint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 104,
          child: Row(
            children: [
              Expanded(
                child: ReorderableListView.builder(
                  scrollDirection: Axis.horizontal,
                  buildDefaultDragHandles: false,
                  itemCount: pages.length,
                  onReorderItem: (oldIndex, newIndex) =>
                      context.read<ScanSessionBloc>().add(
                        ScanSessionPagesReordered(
                          oldIndex: oldIndex,
                          newIndex: newIndex,
                        ),
                      ),
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return Padding(
                      key: ValueKey('scan-thumbnail-${page.id}'),
                      padding: const EdgeInsets.only(right: 8),
                      child: ReorderableDelayedDragStartListener(
                        index: index,
                        child: _PageThumbnail(
                          page: page,
                          pageNumber: index + 1,
                          isSelected: index == state.selectedPageIndex,
                          onTap: () => context.read<ScanSessionBloc>().add(
                            ScanSessionPageSelected(index),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 4),
              _AddPageButton(onPressed: onAddPage),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onCancel,
                icon: const Icon(LucideIcons.x, size: 19),
                label: Text(t.scanEditorCancel),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                key: const ValueKey('scan-editor-continue'),
                onPressed: onContinue,
                iconAlignment: IconAlignment.end,
                icon: const Icon(LucideIcons.arrowRight, size: 19),
                label: Text(t.scanEditorContinue),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PagePreview extends StatelessWidget {
  const _PagePreview({required this.page});

  final DocumentPage page;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 4,
          child: Center(
            child: AspectRatio(
              aspectRatio: page.pixelWidth / page.pixelHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(page.displayImagePath),
                    key: ValueKey('scan-preview-${page.id}'),
                    fit: BoxFit.fill,
                    errorBuilder: (_, _, _) => const _ImageUnavailable(),
                  ),
                  IgnorePointer(
                    child: CustomPaint(
                      painter: DocumentCornersPainter(
                        corners: page.corners,
                        lineColor: colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EdgeDetectionControl extends StatelessWidget {
  const _EdgeDetectionControl({required this.page, required this.onPressed});

  final DocumentPage page;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = context.l10n;
    final isConfirmed =
        page.corners.source == DocumentCornersSource.detected ||
        page.corners.source == DocumentCornersSource.manual;
    final label = switch (page.corners.source) {
      DocumentCornersSource.manual => t.documentCornersAdjusted,
      DocumentCornersSource.detected => t.documentEdgesDetected,
      DocumentCornersSource.fullImage => switch (page.edgeDetectionStatus) {
        DocumentEdgeDetectionStatus.failed => t.documentEdgeDetectionFailed,
        DocumentEdgeDetectionStatus.notFound ||
        DocumentEdgeDetectionStatus.notStarted => t.documentEdgesNotFound,
        DocumentEdgeDetectionStatus.detected => t.documentEdgesDetected,
      },
    };

    return Row(
      children: [
        Icon(
          isConfirmed ? LucideIcons.scanLine : LucideIcons.info,
          size: 18,
          color: isConfirmed
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isConfirmed
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton.icon(
          key: const ValueKey('scan-editor-adjust-corners'),
          onPressed: onPressed,
          icon: const Icon(LucideIcons.crop, size: 18),
          label: Text(t.scanAdjustCorners),
        ),
      ],
    );
  }
}

class _PageThumbnail extends StatelessWidget {
  const _PageThumbnail({
    required this.page,
    required this.pageNumber,
    required this.isSelected,
    required this.onTap,
  });

  final DocumentPage page;
  final int pageNumber;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      selected: isSelected,
      label: context.l10n.scanEditorPageNumber(pageNumber),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 74,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(
                  File(page.displayImagePath),
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const _ImageUnavailable(iconSize: 24),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 24,
                  alignment: Alignment.center,
                  color: colorScheme.surface.withValues(alpha: 0.88),
                  child: Text(
                    '$pageNumber',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddPageButton extends StatelessWidget {
  const _AddPageButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: context.l10n.scanEditorAddPage,
      child: InkWell(
        key: const ValueKey('scan-editor-add-page'),
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 64,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.08),
            border: Border.all(color: colorScheme.primary),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.plus, color: colorScheme.primary, size: 24),
              const SizedBox(height: 5),
              Text(
                context.l10n.scanEditorAdd,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyEditor extends StatelessWidget {
  const _EmptyEditor({required this.onAddPage});

  final VoidCallback onAddPage;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = context.l10n;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              ScanlyIcons.scanDocument,
              size: 64,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              t.scanEditorEmptyTitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              t.scanEditorEmptySubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAddPage,
              icon: const Icon(LucideIcons.camera),
              label: Text(t.scanEditorAddPage),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageUnavailable extends StatelessWidget {
  const _ImageUnavailable({this.iconSize = 48});

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: colorScheme.surfaceContainer,
      child: Center(
        child: Icon(
          LucideIcons.imageOff,
          size: iconSize,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
