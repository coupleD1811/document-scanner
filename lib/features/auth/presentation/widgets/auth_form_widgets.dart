import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../l10n/l10n.dart';

class AuthBrandLogo extends StatelessWidget {
  const AuthBrandLogo({super.key, this.width = 220, this.height = 74});

  static const assetPath = 'images/logo/logo_icon.png';

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: t.appTitle,
      child: SizedBox(
        key: const ValueKey('auth-brand-logo'),
        width: width,
        height: height,
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, _, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.scanLine,
                  color: colorScheme.primary,
                  size: 34,
                ),
                const SizedBox(width: 10),
                Text(
                  t.appTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.8),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class AuthSocialButton extends StatelessWidget {
  const AuthSocialButton({
    required this.assetPath,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String assetPath;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        minimumSize: const Size.fromHeight(54),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        side: BorderSide(color: colorScheme.outlineVariant),
        textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 28,
              height: 24,
              child: Center(
                child: Image.asset(
                  assetPath,
                  height: 22,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
