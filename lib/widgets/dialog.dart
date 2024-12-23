import 'package:flutter/material.dart';

Future<void> showLogoutDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
  required String title, // Pass the translated title
  required String message, // Pass the translated message
  required String confirmText, // Pass the translated confirm button text
  required String cancelText, // Pass the translated cancel button text
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              if (onCancel != null) onCancel();
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              onConfirm(); // Execute the confirm callback
            },
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}
