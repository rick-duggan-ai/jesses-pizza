import 'package:flutter/material.dart';
import 'package:jesses_pizza_app/domain/models/transaction.dart';

String _formatDateTime(DateTime dt) {
  const months = ['January', 'February', 'March', 'April', 'May', 'June',
                  'July', 'August', 'September', 'October', 'November', 'December'];
  final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
  final ampm = dt.hour < 12 ? 'AM' : 'PM';
  final min = dt.minute.toString().padLeft(2, '0');
  return '${months[dt.month - 1]} ${dt.day}, ${dt.year} $hour:$min $ampm';
}

class OrderDetailScreen extends StatelessWidget {
  final Transaction order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDateTime(order.date);
    final totalStr = '\$${order.total.toStringAsFixed(2)}';
    final typeStr = order.isDelivery ? 'Delivery' : 'Pickup';

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _InfoRow(label: 'Date', value: dateStr),
          _InfoRow(label: 'Type', value: typeStr),
          if (order.transactionState != null)
            _InfoRow(label: 'Status', value: order.transactionState!),
          if (order.name != null)
            _InfoRow(label: 'Name', value: order.name!),
          const Divider(height: 24),
          const Text('Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text('${item.quantity}x ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(
                      item.sizeName != null
                          ? '${item.name} (${item.sizeName})'
                          : item.name,
                    ),
                  ),
                  Text('\$${item.price.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(totalStr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
