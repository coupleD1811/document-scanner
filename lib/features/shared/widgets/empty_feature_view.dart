import 'package:flutter/material.dart';

class EmptyFeatureView extends StatelessWidget {
  const EmptyFeatureView({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isInScrollView = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isInScrollView;

  @override
  Widget build(BuildContext context) {
    final content = _EmptyFeatureContent(
      icon: icon,
      title: title,
      subtitle: subtitle,
    );

    if (isInScrollView) {
      return content;
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: content,
      ),
    );
  }
}

class _EmptyFeatureContent extends StatelessWidget {
  const _EmptyFeatureContent({
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
    final textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Icon(icon, color: colorScheme.primary, size: 44),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
