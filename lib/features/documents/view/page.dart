import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_selector/file_selector.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/theme/scanly_icons.dart';
import '../../../l10n/l10n.dart';
import '../bloc/document_action_bloc.dart';
import '../bloc/document_import_bloc.dart';
import '../bloc/document_import_event.dart';
import '../bloc/document_import_state.dart';
import '../bloc/document_list_bloc.dart';
import '../model/document_item.dart';
import '../model/document_list_query.dart';
import '../service/document_file_picker.dart';
import '../service/document_import_service.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({
    this.onScanPressed,
    this.onImportPressed,
    this.filePicker = const SystemDocumentFilePicker(),
    super.key,
  });

  final VoidCallback? onScanPressed;
  final VoidCallback? onImportPressed;
  final DocumentFilePicker filePicker;

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DocumentListBloc>().state;

    return MultiBlocListener(
      listeners: [
        BlocListener<DocumentActionBloc, DocumentActionState>(
          listenWhen: (previous, current) => current is! DocumentActionInitial,
          listener: _handleActionState,
        ),
        BlocListener<DocumentImportBloc, DocumentImportState>(
          listenWhen: (previous, current) => current is! DocumentImportInitial,
          listener: _handleImportState,
        ),
      ],
      child: CustomScrollView(
        key: const ValueKey('documents-page'),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            sliver: SliverToBoxAdapter(
              child: _DocumentsHeader(
                searchController: _searchController,
                searchFocusNode: _searchFocusNode,
                selectedFilter: state.query.filter,
                onSearchChanged: (value) {
                  context.read<DocumentListBloc>().add(
                    DocumentListSearchChanged(value),
                  );
                },
                onSearchPressed: _searchFocusNode.requestFocus,
                onFilterPressed: _showFilterPicker,
                onFilterChanged: (filter) {
                  context.read<DocumentListBloc>().add(
                    DocumentListFilterChanged(filter),
                  );
                },
              ),
            ),
          ),
          if (state is DocumentListLoading)
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 48, 20, 0),
              sliver: SliverToBoxAdapter(child: _DocumentsLoadingState()),
            )
          else if (state is DocumentListFailure)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _DocumentsFailureState(
                  onRetryPressed: () => context.read<DocumentListBloc>().add(
                    const DocumentListSubscriptionRequested(),
                  ),
                ),
              ),
            )
          else if (state is DocumentListReady && !state.hasDocuments) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _DocumentsEmptyState(
                  onScanPressed: _handleScanPressed,
                  onImportPressed: _handleImportPressed,
                ),
              ),
            ),
          ] else if (state is DocumentListReady) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 16),
              sliver: SliverToBoxAdapter(
                child: _DocumentListControls(
                  documentCount: state.documents.length,
                  newestFirst: state.query.sort == DocumentListSort.recent,
                  onSortPressed: () {
                    final sort = state.query.sort == DocumentListSort.recent
                        ? DocumentListSort.oldest
                        : DocumentListSort.recent;
                    context.read<DocumentListBloc>().add(
                      DocumentListSortChanged(sort),
                    );
                  },
                  onImportPressed: _handleImportPressed,
                ),
              ),
            ),
            if (state.documents.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: _NoSearchResults(
                    onClearPressed: _clearSearchAndFilters,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList.builder(
                  itemCount: state.documents.length,
                  itemBuilder: (context, index) {
                    final document = state.documents[index];

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == state.documents.length - 1 ? 0 : 12,
                      ),
                      child: _DocumentCard(
                        document: document,
                        onPressed: () => context.read<DocumentActionBloc>().add(
                          DocumentOpenRequested(document.id),
                        ),
                        onMorePressed: () => _showDocumentActions(document),
                      ),
                    );
                  },
                ),
              ),
          ],
          const SliverPadding(padding: EdgeInsets.only(bottom: 28)),
        ],
      ),
    );
  }

  void _handleImportState(BuildContext context, DocumentImportState state) {
    final message = switch (state) {
      DocumentImportSuccess() => context.l10n.documentImportSuccess(
        state.document.name,
      ),
      DocumentImportFailure() => _importFailureMessage(context.l10n, state),
      _ => null,
    };
    if (message == null) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: state is DocumentImportFailure
              ? Theme.of(context).colorScheme.error
              : null,
        ),
      );
  }

  String _importFailureMessage(
    AppLocalizations t,
    DocumentImportFailure state,
  ) {
    return switch (state.reason) {
      DocumentImportFailureReason.sourceUnavailable =>
        t.documentImportUnavailable,
      DocumentImportFailureReason.unsupportedImage => t.imageImportUnsupported,
      DocumentImportFailureReason.fileTooLarge => t.documentImportTooLarge,
      DocumentImportFailureReason.passwordProtectedPdf =>
        t.pdfImportPasswordProtected,
      DocumentImportFailureReason.invalidPdf => t.pdfImportFailed,
    };
  }

  void _handleActionState(BuildContext context, DocumentActionState state) {
    final t = context.l10n;
    final message = switch (state) {
      DocumentActionSuccess(action: DocumentAction.rename) =>
        t.documentRenameSuccess(state.documentName),
      DocumentActionSuccess(action: DocumentAction.delete) =>
        t.documentDeleteSuccess,
      DocumentActionFailure() => _actionFailureMessage(t, state),
      _ => null,
    };

    if (message == null) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: state is DocumentActionFailure
              ? Theme.of(context).colorScheme.error
              : null,
        ),
      );
  }

  String _actionFailureMessage(
    AppLocalizations t,
    DocumentActionFailure state,
  ) {
    return switch (state.reason) {
      DocumentActionFailureReason.invalidName => t.documentNameInvalid,
      DocumentActionFailureReason.notFound ||
      DocumentActionFailureReason.fileUnavailable => t.documentUnavailable,
      DocumentActionFailureReason.unexpected => switch (state.action) {
        DocumentAction.open => t.documentActionOpenFailed,
        DocumentAction.rename => t.documentActionRenameFailed,
        DocumentAction.share => t.documentActionShareFailed,
        DocumentAction.delete => t.documentActionDeleteFailed,
      },
    };
  }

  void _handleScanPressed() {
    final callback = widget.onScanPressed;
    if (callback != null) {
      callback();
      return;
    }

    _showFeatureUnavailable();
  }

  Future<void> _handleImportPressed() async {
    final callback = widget.onImportPressed;
    if (callback != null) {
      callback();
      return;
    }

    final type = await showModalBottomSheet<_DocumentImportSelection>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final t = context.l10n;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  key: const ValueKey('documents-import-images-option'),
                  leading: const Icon(LucideIcons.images),
                  title: Text(t.importImagesAction),
                  subtitle: Text(t.importImagesSubtitle),
                  onTap: () => Navigator.of(
                    context,
                  ).pop(_DocumentImportSelection.images),
                ),
                ListTile(
                  key: const ValueKey('documents-import-pdf-option'),
                  leading: const Icon(ScanlyIcons.importPdf),
                  title: Text(t.importPdfAction),
                  subtitle: Text(t.importPdfSubtitle),
                  onTap: () =>
                      Navigator.of(context).pop(_DocumentImportSelection.pdf),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (!mounted || type == null) {
      return;
    }

    try {
      switch (type) {
        case _DocumentImportSelection.images:
          final files = await widget.filePicker.pickImages();
          if (!mounted || files.isEmpty) {
            return;
          }
          context.read<DocumentImportBloc>().add(
            DocumentImagesImportRequested(
              sourcePaths: files.map((file) => file.path).toList(),
              name: _imageImportName(files),
            ),
          );
        case _DocumentImportSelection.pdf:
          final file = await widget.filePicker.pickPdf();
          if (!mounted || file == null) {
            return;
          }
          context.read<DocumentImportBloc>().add(
            DocumentPdfImportRequested(
              sourcePath: file.path,
              name: _nameWithoutExtension(file.name),
            ),
          );
      }
    } on Object {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(context.l10n.pdfImportFailed),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
    }
  }

  String _imageImportName(List<XFile> files) {
    if (files.length == 1) {
      return _nameWithoutExtension(files.single.name);
    }
    return context.l10n.importedImagesDocumentName(files.length);
  }

  String _nameWithoutExtension(String value) {
    final extensionIndex = value.lastIndexOf('.');
    if (extensionIndex <= 0) {
      return value;
    }
    return value.substring(0, extensionIndex);
  }

  void _clearSearchAndFilters() {
    _searchController.clear();
    final bloc = context.read<DocumentListBloc>();
    bloc
      ..add(const DocumentListSearchChanged(''))
      ..add(const DocumentListFilterChanged(DocumentListFilter.all));
  }

  Future<void> _showFilterPicker() async {
    final selectedFilter = await showModalBottomSheet<DocumentListFilter>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final t = context.l10n;
        final currentFilter = context
            .read<DocumentListBloc>()
            .state
            .query
            .filter;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.documentsFilterTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                for (final filter in DocumentListFilter.values)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      _filterIcon(filter),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(_filterLabel(t, filter)),
                    trailing: filter == currentFilter
                        ? Icon(
                            LucideIcons.check,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () => Navigator.of(context).pop(filter),
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedFilter != null && mounted) {
      context.read<DocumentListBloc>().add(
        DocumentListFilterChanged(selectedFilter),
      );
    }
  }

  Future<void> _showDocumentActions(DocumentItem document) async {
    final t = context.l10n;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                _DocumentActionTile(
                  icon: LucideIcons.fileText,
                  label: t.openAction,
                  onPressed: () => _dispatchAction(
                    context,
                    DocumentOpenRequested(document.id),
                  ),
                ),
                _DocumentActionTile(
                  icon: LucideIcons.pencil,
                  label: t.renameAction,
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showRenameDialog(document);
                  },
                ),
                _DocumentActionTile(
                  icon: LucideIcons.share2,
                  label: t.shareAction,
                  onPressed: () => _dispatchAction(
                    context,
                    DocumentShareRequested(document.id),
                  ),
                ),
                _DocumentActionTile(
                  icon: LucideIcons.folder,
                  label: t.moveAction,
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showFeatureUnavailable();
                  },
                ),
                _DocumentActionTile(
                  icon: LucideIcons.trash2,
                  label: t.deleteAction,
                  isDestructive: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showDeleteDialog(document);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showRenameDialog(DocumentItem document) async {
    final controller = TextEditingController(
      text: _nameWithoutPdfExtension(document.name),
    );
    final name = await showDialog<String>(
      context: context,
      builder: (context) {
        final t = context.l10n;

        return AlertDialog(
          title: Text(t.documentRenameTitle),
          content: TextField(
            key: const ValueKey('document-rename-field'),
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (value) => Navigator.of(context).pop(value),
            decoration: InputDecoration(labelText: t.documentNameLabel),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.cancelAction),
            ),
            FilledButton(
              key: const ValueKey('document-rename-save-button'),
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text(t.renameAction),
            ),
          ],
        );
      },
    );
    controller.dispose();

    if (name != null && mounted) {
      context.read<DocumentActionBloc>().add(
        DocumentRenameRequested(documentId: document.id, name: name),
      );
    }
  }

  Future<void> _showDeleteDialog(DocumentItem document) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final t = context.l10n;

        return AlertDialog(
          title: Text(t.documentDeleteTitle),
          content: Text(t.documentDeleteMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(t.cancelAction),
            ),
            FilledButton(
              key: const ValueKey('document-delete-confirm-button'),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(t.deleteAction),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      context.read<DocumentActionBloc>().add(
        DocumentDeleteRequested(document.id),
      );
    }
  }

  void _dispatchAction(BuildContext sheetContext, DocumentActionEvent event) {
    Navigator.of(sheetContext).pop();
    context.read<DocumentActionBloc>().add(event);
  }

  String _nameWithoutPdfExtension(String value) {
    return value.toLowerCase().endsWith('.pdf')
        ? value.substring(0, value.length - 4)
        : value;
  }

  void _showFeatureUnavailable() {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(context.l10n.documentsFeatureComingSoon)),
      );
  }
}

enum _DocumentImportSelection { images, pdf }

class _DocumentsHeader extends StatelessWidget {
  const _DocumentsHeader({
    required this.searchController,
    required this.searchFocusNode,
    required this.selectedFilter,
    required this.onSearchChanged,
    required this.onSearchPressed,
    required this.onFilterPressed,
    required this.onFilterChanged,
  });

  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final DocumentListFilter selectedFilter;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchPressed;
  final VoidCallback onFilterPressed;
  final ValueChanged<DocumentListFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final t = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                t.tabDocuments,
                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            _HeaderIconButton(
              tooltip: t.searchDocumentsHint,
              icon: LucideIcons.search,
              onPressed: onSearchPressed,
            ),
            const SizedBox(width: 6),
            _HeaderIconButton(
              tooltip: t.documentsFilterTitle,
              icon: LucideIcons.slidersHorizontal,
              onPressed: onFilterPressed,
            ),
          ],
        ),
        const SizedBox(height: 24),
        TextField(
          key: const ValueKey('documents-search-field'),
          controller: searchController,
          focusNode: searchFocusNode,
          onChanged: onSearchChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: t.searchDocumentsHint,
            prefixIcon: const Icon(LucideIcons.search),
            suffixIcon: searchController.text.isEmpty
                ? null
                : IconButton(
                    tooltip: t.clearSearchAction,
                    onPressed: () {
                      searchController.clear();
                      onSearchChanged('');
                    },
                    icon: const Icon(LucideIcons.circleX),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            for (final filter in DocumentListFilter.values) ...[
              Expanded(
                child: _DocumentFilterChip(
                  key: ValueKey('documents-filter-${filter.name}'),
                  label: _filterLabel(t, filter),
                  isSelected: filter == selectedFilter,
                  onPressed: () => onFilterChanged(filter),
                ),
              ),
              if (filter != DocumentListFilter.values.last)
                const SizedBox(width: 10),
            ],
          ],
        ),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      minimumSize: const Size.square(42),
      padding: EdgeInsets.zero,
      child: Tooltip(
        message: tooltip,
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.onSurface,
          size: 28,
        ),
      ),
    );
  }
}

class _DocumentFilterChip extends StatelessWidget {
  const _DocumentFilterChip({
    required this.label,
    required this.isSelected,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: isSelected
          ? colorScheme.primary.withValues(alpha: 0.08)
          : colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: const BoxConstraints(minWidth: 68, minHeight: 40),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _DocumentsEmptyState extends StatelessWidget {
  const _DocumentsEmptyState({
    required this.onScanPressed,
    required this.onImportPressed,
  });

  final VoidCallback onScanPressed;
  final VoidCallback onImportPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final t = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 44, 24, 36),
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Icon(
                  LucideIcons.folderOpen,
                  color: colorScheme.primary,
                  size: 58,
                ),
              ),
            ),
            const SizedBox(height: 26),
            Text(
              t.documentsEmptyTitle,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              t.documentsEmptySubtitle,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 30),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      key: const ValueKey('documents-scan-button'),
                      onPressed: onScanPressed,
                      child: Text(t.homeScanDocumentAction),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      key: const ValueKey('documents-import-button'),
                      onPressed: onImportPressed,
                      child: Text(t.quickImportPdf),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentsLoadingState extends StatelessWidget {
  const _DocumentsLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      ),
    );
  }
}

class _DocumentsFailureState extends StatelessWidget {
  const _DocumentsFailureState({required this.onRetryPressed});

  final VoidCallback onRetryPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(LucideIcons.triangleAlert, color: colorScheme.error, size: 42),
            const SizedBox(height: 16),
            Text(
              t.documentsLoadFailed,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              key: const ValueKey('documents-retry-button'),
              onPressed: onRetryPressed,
              child: Text(t.retryAction),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentListControls extends StatelessWidget {
  const _DocumentListControls({
    required this.documentCount,
    required this.newestFirst,
    required this.onSortPressed,
    required this.onImportPressed,
  });

  final int documentCount;
  final bool newestFirst;
  final VoidCallback onSortPressed;
  final VoidCallback onImportPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final t = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _documentCountText(t, documentCount),
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CupertinoButton(
              key: const ValueKey('documents-sort-button'),
              onPressed: onSortPressed,
              minimumSize: const Size(0, 40),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.arrowUpDown,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    newestFirst ? t.sortRecent : t.sortOldest,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    LucideIcons.chevronDown,
                    color: colorScheme.onSurfaceVariant,
                    size: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          key: const ValueKey('documents-list-import-button'),
          onPressed: onImportPressed,
          icon: const Icon(ScanlyIcons.importPdf, size: 20),
          label: Text(t.quickImportPdf),
        ),
      ],
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.document,
    required this.onPressed,
    required this.onMorePressed,
  });

  final DocumentItem document;
  final VoidCallback onPressed;
  final VoidCallback onMorePressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final t = context.l10n;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: const BoxConstraints(minHeight: 124),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DocumentThumbnail(
                type: document.type,
                thumbnailPath: document.thumbnailPath,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      _documentMetadataText(context, document),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                    if (document.hasOcrText) ...[
                      const SizedBox(height: 10),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          child: Text(
                            t.ocrReadyLabel,
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              CupertinoButton(
                key: ValueKey('document-more-${document.id}'),
                onPressed: onMorePressed,
                minimumSize: const Size.square(40),
                padding: EdgeInsets.zero,
                child: Icon(
                  LucideIcons.ellipsis,
                  color: colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentThumbnail extends StatelessWidget {
  const _DocumentThumbnail({required this.type, this.thumbnailPath});

  final DocumentType type;
  final String? thumbnailPath;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPdf = type == DocumentType.pdf;

    return Container(
      width: 76,
      height: 96,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: thumbnailPath == null
            ? _DocumentThumbnailPlaceholder(isPdf: isPdf)
            : Image.file(
                File(thumbnailPath!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _DocumentThumbnailPlaceholder(isPdf: isPdf);
                },
              ),
      ),
    );
  }
}

class _DocumentThumbnailPlaceholder extends StatelessWidget {
  const _DocumentThumbnailPlaceholder({required this.isPdf});

  final bool isPdf;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isPdf ? LucideIcons.fileText : LucideIcons.image,
                color: colorScheme.primary,
                size: 24,
              ),
              const Spacer(),
              for (final width in [44.0, 52.0, 34.0]) ...[
                Container(
                  width: width,
                  height: 3,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ],
          ),
        ),
        Positioned(
          left: 10,
          bottom: 10,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isPdf ? const Color(0xFFDC2626) : colorScheme.primary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Text(
                isPdf ? 'PDF' : 'SCAN',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NoSearchResults extends StatelessWidget {
  const _NoSearchResults({required this.onClearPressed});

  final VoidCallback onClearPressed;

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Icon(LucideIcons.fileSearch, color: colorScheme.primary, size: 46),
            const SizedBox(height: 18),
            Text(
              t.noMatchingDocumentsTitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              t.noMatchingDocumentsSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            TextButton(
              onPressed: onClearPressed,
              child: Text(t.clearSearchAction),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentActionTile extends StatelessWidget {
  const _DocumentActionTile({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.onSurface;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      onTap: onPressed,
    );
  }
}

String _filterLabel(AppLocalizations t, DocumentListFilter filter) {
  return switch (filter) {
    DocumentListFilter.all => t.documentFilterAll,
    DocumentListFilter.scans => t.documentFilterScans,
    DocumentListFilter.pdfs => t.documentFilterPdfs,
  };
}

IconData _filterIcon(DocumentListFilter filter) {
  return switch (filter) {
    DocumentListFilter.all => LucideIcons.folder,
    DocumentListFilter.scans => ScanlyIcons.scanDocument,
    DocumentListFilter.pdfs => LucideIcons.fileText,
  };
}

String _documentCountText(AppLocalizations t, int count) {
  return switch (t.localeName) {
    'ja' => '$count ${t.documentsCountLabel}',
    _ => '$count ${t.documentsCountLabel}',
  };
}

String _documentMetadataText(BuildContext context, DocumentItem document) {
  final t = context.l10n;
  final locale = Localizations.localeOf(context).toLanguageTag();
  final date = DateFormat.yMMMd(locale).format(document.updatedAt);
  final pageCount = _pageCountText(t, document.pageCount);
  final size = _formatFileSize(document.sizeInBytes);

  return '$date  •  $pageCount  •  $size';
}

String _pageCountText(AppLocalizations t, int count) {
  if (t.localeName == 'ja') {
    return '$count ${t.pagesLabel}';
  }

  final label = count == 1 ? t.pageLabel : t.pagesLabel;
  return '$count $label';
}

String _formatFileSize(int bytes) {
  const bytesPerKilobyte = 1024;
  const bytesPerMegabyte = bytesPerKilobyte * 1024;

  if (bytes >= bytesPerMegabyte) {
    final size = bytes / bytesPerMegabyte;
    return '${size.toStringAsFixed(size >= 10 ? 0 : 1)} MB';
  }

  return '${(bytes / bytesPerKilobyte).ceil()} KB';
}
