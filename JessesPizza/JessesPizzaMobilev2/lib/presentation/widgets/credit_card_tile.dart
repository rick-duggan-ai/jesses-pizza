import 'package:flutter/material.dart';
import 'package:jesses_pizza_app/domain/models/credit_card.dart';

class CreditCardTile extends StatelessWidget {
  final CreditCard card;
  final bool selected;
  final VoidCallback onTap;

  const CreditCardTile({
    super.key,
    required this.card,
    required this.onTap,
    this.selected = false,
  });

  String get _maskedNumber {
    final n = card.maskedCardNumber;
    if (n.length >= 4) {
      return '**** **** **** ${n.substring(n.length - 4)}';
    }
    return n;
  }

  /// Map card type to an appropriate icon based on the card number prefix.
  /// Visa starts with 4, Mastercard with 5, Amex with 3 (34/37),
  /// Discover with 6.
  IconData get _cardTypeIcon {
    final n = card.maskedCardNumber.replaceAll(RegExp(r'\D'), '');
    if (n.isEmpty) return Icons.credit_card;

    if (n.startsWith('4')) return Icons.payment; // Visa
    if (n.startsWith('5')) return Icons.credit_card; // Mastercard
    if (n.startsWith('34') || n.startsWith('37')) {
      return Icons.card_membership; // Amex
    }
    if (n.startsWith('6')) return Icons.credit_score; // Discover

    return Icons.credit_card; // fallback
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: selected
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        leading: Icon(_cardTypeIcon),
        title: Text(_maskedNumber),
        subtitle: Text('Exp: ${card.expirationDate}'),
        trailing: selected
            ? Icon(Icons.check_circle,
                color: Theme.of(context).colorScheme.primary)
            : null,
        onTap: onTap,
      ),
    );
  }
}
