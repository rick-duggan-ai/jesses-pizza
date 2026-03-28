import 'package:flutter/material.dart';

/// A dialog displayed when an HPP payment is declined or fails.
///
/// Shows an icon, title, message body, and a single action button.
class PaymentResultDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final IconData icon;
  final Color iconColor;

  const PaymentResultDialog({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    this.icon = Icons.error_outline,
    this.iconColor = Colors.red,
  });

  /// Shows a "Card was declined" dialog with an OK button.
  static Future<void> showDecline(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PaymentResultDialog(
        title: 'Payment Declined',
        message: 'Your card was declined. Please try a different card '
            'or contact your card issuer.',
        buttonText: 'OK',
        icon: Icons.credit_card_off,
      ),
    );
  }

  /// Shows a payment failure dialog with the server error message
  /// and a "Try Again" button.
  static Future<void> showFailure(
    BuildContext context, {
    required String message,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PaymentResultDialog(
        title: 'Payment Failed',
        message: message,
        buttonText: 'Try Again',
        icon: Icons.warning_amber_rounded,
        iconColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(icon, size: 48, color: iconColor),
      title: Text(title),
      content: Text(message),
      actions: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
          ),
        ),
      ],
    );
  }
}
