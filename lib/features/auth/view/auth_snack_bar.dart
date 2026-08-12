import 'package:flutter/material.dart';

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
              isError ? Icons.error_outline : Icons.check_circle_outline,
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
