import 'package:flutter/material.dart';

Future<void> showErrorMessageDialog({
  required BuildContext context,
  required String message,
}) => showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Xatolik!'),
    content: Text(message),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('OK'),
      ),
    ],
  ),
);
