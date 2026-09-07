import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/theme/scanly_icons.dart';
import '../../../l10n/l10n.dart';
import '../../documents/bloc/document_save_bloc.dart';
import '../bloc/scan_session_bloc.dart';
import '../model/document_corners.dart';
import '../model/document_edge_detection_status.dart';
import '../model/document_page.dart';
import '../model/document_processing_status.dart';
import '../model/normalized_document_image.dart';
import '../model/scan_filter.dart';
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

    return BlocListener<DocumentSaveBloc, DocumentSaveState>(
      listener: _onSaveStateChanged,
      child: PopScope(
        canPop: _canPop,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            unawaited(_cancelSession());
          }
        },
        child: BlocBuilder<ScanSessionBloc, ScanSessionState>(
          builder: (context, state) {
            final editingState = state is ScanSessionEditing ? state : null;
            final isSaving = context.select(
              (DocumentSaveBloc bloc) => bloc.state is DocumentSaveInProgress,
            );

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
                    onPressed: editingState == null || isSaving
                        ? null
                        : () => context.read<ScanSessionBloc>().add(
                            ScanSessionPageRemoved(
                              editingState.selectedPage.id,
                            ),
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
                          isSaving: isSaving,
                          onAddPage: _addPage,
                          onCancel: _cancelSession,
                          onContinue: _continueToPdf,
                          onAdjustCorners: _adjustCorners,
                          onAdjustImage: _adjustImage,
                        ),
                ),
              ),
            );
          },
        ),
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

  Future<void> _adjustImage(DocumentPage page) async {
    final adjustments = await showModalBottomSheet<_ImageAdjustments>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _ImageAdjustmentSheet(
        initialBrightness: page.brightness,
        initialContrast: page.contrast,
      ),
    );
    if (!mounted || adjustments == null) {
      return;
    }

    context.read<ScanSessionBloc>().add(
      ScanSessionPageAdjustmentsChanged(
        pageId: page.id,
        brightness: adjustments.brightness,
        contrast: adjustments.contrast,
      ),
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
    if (_isShowingDiscardDialog ||
        context.read<DocumentSaveBloc>().state is DocumentSaveInProgress) {
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

  Future<void> _continueToPdf() async {
    final session = context.read<ScanSessionBloc>().state.session;
    if (session == null) {
      return;
    }

    final defaultName =
        'Scan ${DateFormat('yyyy-MM-dd_HHmm').format(DateTime.now())}';
    final nameController = TextEditingController(text: defaultName);
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.scanSaveDialogTitle),
        content: TextField(
          key: const ValueKey('scan-save-name-field'),
          controller: nameController,
          autofocus: true,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: context.l10n.scanSaveNameLabel,
            hintText: context.l10n.scanSaveNameHint,
          ),
          onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(context.l10n.scanEditorCancel),
          ),
          FilledButton(
            key: const ValueKey('scan-save-confirm'),
            onPressed: () =>
                Navigator.of(dialogContext).pop(nameController.text),
            child: Text(context.l10n.scanSaveAction),
          ),
        ],
      ),
    );
    nameController.dispose();
    if (!mounted || name == null) {
      return;
    }

    context.read<DocumentSaveBloc>().add(
      DocumentSaveRequested(session: session, name: name),
    );
  }

  void _onSaveStateChanged(BuildContext context, DocumentSaveState state) {
    if (state case DocumentSaveSuccess(:final document)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(context.l10n.scanSaveSuccess(document.name))),
        );
      context.read<ScanSessionBloc>().add(const ScanSessionCleared());
      _leaveEditor();
      return;
    }

    if (state case DocumentSaveFailure(:final reason)) {
      final message = switch (reason) {
        DocumentSaveFailureReason.invalidInput =>
          context.l10n.scanSaveInvalidInput,
        DocumentSaveFailureReason.pageNotReady =>
          context.l10n.scanSavePageNotReady,
        DocumentSaveFailureReason.storage => context.l10n.scanSaveFailed,
      };
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
    }
  }
}

class _EditorContent extends StatelessWidget {
  const _EditorContent({
    required this.state,
    required this.isSaving,
    required this.onAddPage,
    required this.onCancel,
    required this.onContinue,
    required this.onAdjustCorners,
    required this.onAdjustImage,
  });

  final ScanSessionEditing state;
  final bool isSaving;
  final VoidCallback onAddPage;
  final VoidCallback onCancel;
  final VoidCallback onContinue;
  final ValueChanged<DocumentPage> onAdjustCorners;
  final ValueChanged<DocumentPage> onAdjustImage;

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
        _PageEditToolbar(
          isEnabled:
              !isSaving &&
              selectedPage.processingStatus !=
                  DocumentProcessingStatus.processing,
          onRotateLeft: () => context.read<ScanSessionBloc>().add(
            ScanSessionPageRotationRequested(
              pageId: selectedPage.id,
              quarterTurns: -1,
            ),
          ),
          onAdjustCorners: () => onAdjustCorners(selectedPage),
          onRotateRight: () => context.read<ScanSessionBloc>().add(
            ScanSessionPageRotationRequested(
              pageId: selectedPage.id,
              quarterTurns: 1,
            ),
          ),
          onAdjustImage: () => onAdjustImage(selectedPage),
        ),
        const SizedBox(height: 8),
        _ScanFilterSelector(
          selectedFilter: selectedPage.filter,
          isEnabled:
              !isSaving &&
              selectedPage.processingStatus !=
                  DocumentProcessingStatus.processing,
          onChanged: (filter) => context.read<ScanSessionBloc>().add(
            ScanSessionPageFilterChanged(
              pageId: selectedPage.id,
              filter: filter,
            ),
          ),
        ),
        const SizedBox(height: 4),
        _EdgeDetectionControl(
          page: selectedPage,
          onRetryPressed: () => context.read<ScanSessionBloc>().add(
            ScanSessionPageProcessingRequested(selectedPage.id),
          ),
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
              _AddPageButton(onPressed: isSaving ? null : onAddPage),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isSaving ? null : onCancel,
                icon: const Icon(LucideIcons.x, size: 19),
                label: Text(t.scanEditorCancel),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                key: const ValueKey('scan-editor-continue'),
                onPressed: isSaving ? null : onContinue,
                iconAlignment: IconAlignment.end,
                icon: isSaving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(LucideIcons.arrowRight, size: 19),
                label: Text(isSaving ? t.scanSaving : t.scanEditorContinue),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PageEditToolbar extends StatelessWidget {
  const _PageEditToolbar({
    required this.isEnabled,
    required this.onRotateLeft,
    required this.onAdjustCorners,
    required this.onRotateRight,
    required this.onAdjustImage,
  });

  final bool isEnabled;
  final VoidCallback onRotateLeft;
  final VoidCallback onAdjustCorners;
  final VoidCallback onRotateRight;
  final VoidCallback onAdjustImage;

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    return Row(
      children: [
        Expanded(
          child: _PageEditButton(
            key: const ValueKey('scan-editor-rotate-left'),
            icon: LucideIcons.rotateCcw,
            label: t.scanRotateLeft,
            onPressed: isEnabled ? onRotateLeft : null,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PageEditButton(
            key: const ValueKey('scan-editor-adjust-corners'),
            icon: LucideIcons.crop,
            label: t.scanAdjustCorners,
            onPressed: isEnabled ? onAdjustCorners : null,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PageEditButton(
            key: const ValueKey('scan-editor-rotate-right'),
            icon: LucideIcons.rotateCw,
            label: t.scanRotateRight,
            onPressed: isEnabled ? onRotateRight : null,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PageEditButton(
            key: const ValueKey('scan-editor-adjust-image'),
            icon: LucideIcons.slidersHorizontal,
            label: t.scanAdjustImage,
            onPressed: isEnabled ? onAdjustImage : null,
          ),
        ),
      ],
    );
  }
}

class _ScanFilterSelector extends StatelessWidget {
  const _ScanFilterSelector({
    required this.selectedFilter,
    required this.isEnabled,
    required this.onChanged,
  });

  final ScanFilter selectedFilter;
  final bool isEnabled;
  final ValueChanged<ScanFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.scanFilterTitle,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 40,
          width: double.infinity,
          child: SegmentedButton<ScanFilter>(
            segments: [
              ButtonSegment(
                value: ScanFilter.original,
                label: Text(
                  t.scanFilterOriginal,
                  key: const ValueKey('scan-filter-original'),
                ),
              ),
              ButtonSegment(
                value: ScanFilter.color,
                label: Text(
                  t.scanFilterColor,
                  key: const ValueKey('scan-filter-color'),
                ),
              ),
              ButtonSegment(
                value: ScanFilter.grayscale,
                label: Text(
                  t.scanFilterGrayscale,
                  key: const ValueKey('scan-filter-grayscale'),
                ),
              ),
              ButtonSegment(
                value: ScanFilter.blackAndWhite,
                label: Text(
                  t.scanFilterBlackAndWhite,
                  key: const ValueKey('scan-filter-black-white'),
                ),
              ),
            ],
            selected: {selectedFilter},
            onSelectionChanged: isEnabled
                ? (selection) => onChanged(selection.single)
                : null,
            showSelectedIcon: false,
            expandedInsets: EdgeInsets.zero,
            style: ButtonStyle(
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 4),
              ),
              textStyle: WidgetStatePropertyAll(
                Theme.of(context).textTheme.labelSmall,
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PageEditButton extends StatelessWidget {
  const _PageEditButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _ImageAdjustmentSheet extends StatefulWidget {
  const _ImageAdjustmentSheet({
    required this.initialBrightness,
    required this.initialContrast,
  });

  final int initialBrightness;
  final int initialContrast;

  @override
  State<_ImageAdjustmentSheet> createState() => _ImageAdjustmentSheetState();
}

class _ImageAdjustmentSheetState extends State<_ImageAdjustmentSheet> {
  late int _brightness = widget.initialBrightness;
  late int _contrast = widget.initialContrast;

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.scanImageAdjustmentsTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          _AdjustmentSlider(
            key: const ValueKey('scan-brightness-slider'),
            icon: LucideIcons.sun,
            label: t.scanBrightness,
            value: _brightness,
            onChanged: (value) => setState(() => _brightness = value),
          ),
          const SizedBox(height: 16),
          _AdjustmentSlider(
            key: const ValueKey('scan-contrast-slider'),
            icon: LucideIcons.contrast,
            label: t.scanContrast,
            value: _contrast,
            onChanged: (value) => setState(() => _contrast = value),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  key: const ValueKey('scan-adjustments-reset'),
                  onPressed: () => setState(() {
                    _brightness = 0;
                    _contrast = 0;
                  }),
                  child: Text(t.scanAdjustmentReset),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  key: const ValueKey('scan-adjustments-apply'),
                  onPressed: () => Navigator.of(context).pop(
                    _ImageAdjustments(
                      brightness: _brightness,
                      contrast: _contrast,
                    ),
                  ),
                  child: Text(t.scanAdjustmentApply),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdjustmentSlider extends StatelessWidget {
  const _AdjustmentSlider({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final valueLabel = value > 0 ? '+$value' : '$value';

    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: 40,
              child: Text(
                valueLabel,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: -100,
          max: 100,
          divisions: 40,
          label: valueLabel,
          onChanged: (nextValue) => onChanged(nextValue.round()),
        ),
      ],
    );
  }
}

class _ImageAdjustments {
  const _ImageAdjustments({required this.brightness, required this.contrast});

  final int brightness;
  final int contrast;
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
              aspectRatio: page.displayPixelWidth / page.displayPixelHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(page.displayImagePath),
                    key: ValueKey('scan-preview-${page.id}'),
                    fit: BoxFit.fill,
                    errorBuilder: (_, _, _) => const _ImageUnavailable(),
                  ),
                  if (page.processedImagePath == null)
                    IgnorePointer(
                      child: CustomPaint(
                        painter: DocumentCornersPainter(
                          corners: page.corners,
                          lineColor: colorScheme.secondary,
                        ),
                      ),
                    ),
                  if (page.processingStatus ==
                      DocumentProcessingStatus.processing)
                    ColoredBox(
                      color: colorScheme.scrim.withValues(alpha: 0.32),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.onPrimary,
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
  const _EdgeDetectionControl({
    required this.page,
    required this.onRetryPressed,
  });

  final DocumentPage page;
  final VoidCallback onRetryPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = context.l10n;
    final isProcessing =
        page.processingStatus == DocumentProcessingStatus.processing;
    final isCompleted =
        page.processingStatus == DocumentProcessingStatus.completed;
    final isFailed = page.processingStatus == DocumentProcessingStatus.failed;
    final label = switch (page.processingStatus) {
      DocumentProcessingStatus.processing => t.documentPerspectiveCorrecting,
      DocumentProcessingStatus.completed => t.documentPerspectiveCorrected,
      DocumentProcessingStatus.failed => t.documentPerspectiveCorrectionFailed,
      DocumentProcessingStatus.notStarted => switch (page.corners.source) {
        DocumentCornersSource.manual => t.documentCornersAdjusted,
        DocumentCornersSource.detected => t.documentEdgesDetected,
        DocumentCornersSource.fullImage => switch (page.edgeDetectionStatus) {
          DocumentEdgeDetectionStatus.failed => t.documentEdgeDetectionFailed,
          DocumentEdgeDetectionStatus.notFound ||
          DocumentEdgeDetectionStatus.notStarted => t.documentEdgesNotFound,
          DocumentEdgeDetectionStatus.detected => t.documentEdgesDetected,
        },
      },
    };
    final statusColor = isFailed
        ? colorScheme.error
        : isCompleted
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return Row(
      children: [
        if (isProcessing)
          SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.primary,
            ),
          )
        else
          Icon(
            isFailed
                ? LucideIcons.triangleAlert
                : isCompleted
                ? LucideIcons.check
                : LucideIcons.scanLine,
            size: 18,
            color: statusColor,
          ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (isFailed)
          IconButton(
            key: const ValueKey('scan-editor-retry-processing'),
            tooltip: t.documentPerspectiveRetry,
            onPressed: onRetryPressed,
            icon: const Icon(LucideIcons.refreshCw, size: 18),
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

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = onPressed == null
        ? colorScheme.onSurface.withValues(alpha: 0.38)
        : colorScheme.primary;

    return Tooltip(
      message: context.l10n.scanEditorAddPage,
      child: InkWell(
        key: const ValueKey('scan-editor-add-page'),
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 64,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.plus, color: color, size: 24),
              const SizedBox(height: 5),
              Text(
                context.l10n.scanEditorAdd,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
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
