import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_event.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartBloc>();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(item.sizeName,
                      style: Theme.of(context).textTheme.bodySmall),
                  Text('\$${item.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (item.quantity > 1) {
                      cart.add(UpdateQuantity(item.menuItemId, item.sizeName, item.quantity - 1));
                    } else {
                      cart.add(RemoveItem(item.menuItemId, item.sizeName));
                    }
                  },
                ),
                Text('${item.quantity}',
                    style: Theme.of(context).textTheme.titleMedium),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    cart.add(UpdateQuantity(item.menuItemId, item.sizeName, item.quantity + 1));
                  },
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                cart.add(RemoveItem(item.menuItemId, item.sizeName));
              },
            ),
          ],
        ),
      ),
    );
  }
}
