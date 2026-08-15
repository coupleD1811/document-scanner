import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void showAuthSnackBar(
  BuildContext context, {
  required String message,
  required bool isError,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final backgroundColor = isError ? colorScheme.error : colorScheme.primary;
  final foregroundColor = isError ? colorScheme.onError : colorScheme.onPrimary;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: backgroundColor,
        content: Row(
          children: [
            Icon(
              isError ? LucideIcons.circleAlert : LucideIcons.circleCheck,
              color: foregroundColor,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message, style: TextStyle(color: foregroundColor)),
            ),
          ],
        ),
      ),
    );
}
