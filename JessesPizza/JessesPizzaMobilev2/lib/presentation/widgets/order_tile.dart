import 'package:flutter/material.dart';
import 'package:jesses_pizza_app/domain/models/transaction.dart';

String _formatDate(DateTime dt) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
}

class OrderTile extends StatelessWidget {
  final Transaction order;
  final VoidCallback? onTap;

  const OrderTile({super.key, required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(order.date);
    final totalStr = '\$${order.total.toStringAsFixed(2)}';
    final typeStr = order.isDelivery ? 'Delivery' : 'Pickup';

    return ListTile(
      leading: Icon(
        order.isDelivery ? Icons.delivery_dining : Icons.storefront,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(dateStr),
      subtitle: Text(typeStr),
      trailing: Text(
        totalStr,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}
