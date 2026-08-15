import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../l10n/l10n.dart';
import '../model/model.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({
    this.documents = const [],
    this.onScanPressed,
    this.onImportPressed,
    super.key,
  });

  final List<DocumentItem> documents;
  final VoidCallback? onScanPressed;
  final VoidCallback? onImportPressed;

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  _DocumentFilter _selectedFilter = _DocumentFilter.all;
  bool _newestFirst = true;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleDocuments = _visibleDocuments;

    return CustomScrollView(
      key: const ValueKey('documents-page'),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          sliver: SliverToBoxAdapter(
            child: _DocumentsHeader(
              searchController: _searchController,
              searchFocusNode: _searchFocusNode,
              selectedFilter: _selectedFilter,
              onSearchChanged: (_) => setState(() {}),
              onSearchPressed: _searchFocusNode.requestFocus,
              onFilterPressed: _showFilterPicker,
              onFilterChanged: (filter) {
                setState(() => _selectedFilter = filter);
              },
            ),
          ),
        ),
        if (widget.documents.isEmpty) ...[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
            sliver: SliverToBoxAdapter(
              child: _DocumentsEmptyState(
                onScanPressed: _handleScanPressed,
                onImportPressed: _handleImportPressed,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 28)),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(child: _ComingNextSection()),
          ),
        ] else ...[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 16),
            sliver: SliverToBoxAdapter(
              child: _DocumentListControls(
                documentCount: visibleDocuments.length,
                newestFirst: _newestFirst,
                onSortPressed: () {
                  setState(() => _newestFirst = !_newestFirst);
                },
                onImportPressed: _handleImportPressed,
              ),
            ),
          ),
          if (visibleDocuments.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _NoSearchResults(onClearPressed: _clearSearchAndFilters),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList.builder(
                itemCount: visibleDocuments.length,
                itemBuilder: (context, index) {
                  final document = visibleDocuments[index];

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == visibleDocuments.length - 1 ? 0 : 12,
                    ),
                    child: _DocumentCard(
                      document: document,
                      onPressed: () => _showFeatureUnavailable(),
                      onMorePressed: () => _showDocumentActions(document),
                    ),
                  );
                },
              ),
            ),
        ],
        const SliverPadding(padding: EdgeInsets.only(bottom: 28)),
      ],
    );
  }

  List<DocumentItem> get _visibleDocuments {
    final normalizedQuery = _searchController.text.trim().toLowerCase();
    final documents = widget.documents.where((document) {
      final matchesQuery =
          normalizedQuery.isEmpty ||
          document.name.toLowerCase().contains(normalizedQuery);
      final matchesFilter = switch (_selectedFilter) {
        _DocumentFilter.all => true,
        _DocumentFilter.scans => document.type == DocumentType.scan,
        _DocumentFilter.pdfs => document.type == DocumentType.pdf,
      };

      return matchesQuery && matchesFilter;
    }).toList();

    documents.sort((first, second) {
      final comparison = first.updatedAt.compareTo(second.updatedAt);
      return _newestFirst ? -comparison : comparison;
    });

    return documents;
  }

  void _handleScanPressed() {
    final callback = widget.onScanPressed;
    if (callback != null) {
      callback();
      return;
    }

    _showFeatureUnavailable();
  }

  void _handleImportPressed() {
    final callback = widget.onImportPressed;
    if (callback != null) {
      callback();
      return;
    }

    _showFeatureUnavailable();
  }

  void _clearSearchAndFilters() {
    _searchController.clear();
    setState(() => _selectedFilter = _DocumentFilter.all);
  }

  Future<void> _showFilterPicker() async {
    final selectedFilter = await showModalBottomSheet<_DocumentFilter>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final t = context.l10n;

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
                for (final filter in _DocumentFilter.values)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      _filterIcon(filter),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(_filterLabel(t, filter)),
                    trailing: filter == _selectedFilter
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
      setState(() => _selectedFilter = selectedFilter);
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
                  onPressed: () => _closeActionSheet(context),
                ),
                _DocumentActionTile(
                  icon: LucideIcons.pencil,
                  label: t.renameAction,
                  onPressed: () => _closeActionSheet(context),
                ),
                _DocumentActionTile(
                  icon: LucideIcons.share2,
                  label: t.shareAction,
                  onPressed: () => _closeActionSheet(context),
                ),
                _DocumentActionTile(
                  icon: LucideIcons.folder,
                  label: t.moveAction,
                  onPressed: () => _closeActionSheet(context),
                ),
                _DocumentActionTile(
                  icon: LucideIcons.trash2,
                  label: t.deleteAction,
                  isDestructive: true,
                  onPressed: () => _closeActionSheet(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _closeActionSheet(BuildContext sheetContext) {
    Navigator.of(sheetContext).pop();
    _showFeatureUnavailable();
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
  final _DocumentFilter selectedFilter;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchPressed;
  final VoidCallback onFilterPressed;
  final ValueChanged<_DocumentFilter> onFilterChanged;

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
            for (final filter in _DocumentFilter.values) ...[
              Expanded(
                child: _DocumentFilterChip(
                  key: ValueKey('documents-filter-${filter.name}'),
                  label: _filterLabel(t, filter),
                  isSelected: filter == selectedFilter,
                  onPressed: () => onFilterChanged(filter),
                ),
              ),
              if (filter != _DocumentFilter.values.last)
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
              color: isSelected ? colorScheme.primary : const Color(0xFFDDE5EC),
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
        border: Border.all(color: const Color(0xFFDDE5EC)),
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

class _ComingNextSection extends StatelessWidget {
  const _ComingNextSection();

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFDDE5EC)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.documentsComingNextTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            _ComingNextItem(
              icon: LucideIcons.cloud,
              title: t.documentStorageTitle,
              subtitle: t.documentStorageSubtitle,
            ),
            const Divider(height: 1),
            _ComingNextItem(
              icon: LucideIcons.search,
              title: t.searchDocumentsTitle,
              subtitle: t.searchDocumentsSubtitle,
            ),
            const Divider(height: 1),
            _ComingNextItem(
              icon: LucideIcons.scanText,
              title: t.ocrContentSearchTitle,
              subtitle: t.ocrContentSearchSubtitle,
            ),
          ],
        ),
      ),
    );
  }
}

class _ComingNextItem extends StatelessWidget {
  const _ComingNextItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Icon(icon, color: colorScheme.primary, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
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
          icon: const Icon(LucideIcons.upload, size: 20),
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
            border: Border.all(color: const Color(0xFFDDE5EC)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DocumentThumbnail(type: document.type),
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
  const _DocumentThumbnail({required this.type});

  final DocumentType type;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPdf = type == DocumentType.pdf;

    return Container(
      width: 76,
      height: 96,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFCFE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD8E1E8)),
      ),
      child: Stack(
        children: [
          Column(
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
                    color: const Color(0xFFDDE5EC),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ],
          ),
          Positioned(
            left: 0,
            bottom: 0,
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
      ),
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
        border: Border.all(color: const Color(0xFFDDE5EC)),
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

enum _DocumentFilter { all, scans, pdfs }

String _filterLabel(AppLocalizations t, _DocumentFilter filter) {
  return switch (filter) {
    _DocumentFilter.all => t.documentFilterAll,
    _DocumentFilter.scans => t.documentFilterScans,
    _DocumentFilter.pdfs => t.documentFilterPdfs,
  };
}

IconData _filterIcon(_DocumentFilter filter) {
  return switch (filter) {
    _DocumentFilter.all => LucideIcons.folder,
    _DocumentFilter.scans => LucideIcons.scanLine,
    _DocumentFilter.pdfs => LucideIcons.fileText,
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
