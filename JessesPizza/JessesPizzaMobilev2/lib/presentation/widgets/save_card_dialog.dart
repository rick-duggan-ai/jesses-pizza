import 'package:flutter/material.dart';

/// Dialog shown after a successful HPP payment asking whether the user
/// wants to save the card used for future orders.
///
/// Returns `true` if the user taps "Yes", `false` if "No".
class SaveCardDialog extends StatelessWidget {
  const SaveCardDialog({super.key});

  /// Shows the save-card prompt and returns `true` when the user wants
  /// to save, `false` otherwise. Returns `false` if dismissed.
  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const SaveCardDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.credit_card,
        size: 48,
        color: Colors.green,
      ),
      title: const Text('Save Card'),
      content: const Text(
        'Would you like to save this card for future orders?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No Thanks'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Yes, Save It'),
        ),
      ],
    );
  }
}
