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
        leading: const Icon(Icons.credit_card),
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
