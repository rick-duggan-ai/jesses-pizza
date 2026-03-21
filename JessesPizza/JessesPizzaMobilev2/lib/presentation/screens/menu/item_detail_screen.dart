import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';
import 'package:jesses_pizza_app/domain/models/menu_item.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_state.dart';

class ItemDetailScreen extends StatefulWidget {
  final MenuItem item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int _selectedSizeIndex = 0;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final sizes = item.sizes;

    return Scaffold(
      appBar: AppBar(title: Text(item.name ?? '')),
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, menuState) {
          final isStoreOpen = menuState.whenOrNull(
                loaded: (_, __, isOpen, ___) => isOpen,
              ) ??
              true;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: item.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: item.imageUrl!,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            height: 220,
                            color: Colors.grey.shade200,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            height: 220,
                            color: Colors.grey.shade200,
                            child: const Center(
                                child: Icon(Icons.local_pizza, size: 80)),
                          ),
                        )
                      : Container(
                          height: 220,
                          color: Colors.grey.shade200,
                          child: const Center(
                              child: Icon(Icons.local_pizza, size: 80)),
                        ),
                ),

                const SizedBox(height: 16),

                // Name
                Text(
                  item.name ?? '',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                // Description
                if (item.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    item.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],

                const SizedBox(height: 24),

                // Size selection
                if (sizes.isNotEmpty) ...[
                  Text(
                    'Select Size',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  RadioGroup<int>(
                    groupValue: _selectedSizeIndex,
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedSizeIndex = val);
                    },
                    child: Column(
                      children: sizes.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final size = entry.value;
                        return RadioListTile<int>(
                          value: idx,
                          title: Text(size.name),
                          subtitle: Text('\$${size.price.toStringAsFixed(2)}'),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Quantity selector
                Text(
                  'Quantity',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                    ),
                    Text(
                      '$_quantity',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setState(() => _quantity++),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Store closed message
                if (!isStoreOpen)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Store is currently closed. Ordering is unavailable.',
                      style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Add to Cart button
                ElevatedButton(
                  onPressed: isStoreOpen && sizes.isNotEmpty
                      ? _addToCart
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _addToCart() {
    final item = widget.item;
    final size = item.sizes[_selectedSizeIndex];

    final cartItem = CartItem(
      menuItemId: item.id ?? '',
      name: item.name ?? '',
      sizeName: size.name,
      price: size.price,
      quantity: _quantity,
    );

    context.read<CartBloc>().add(AddItem(cartItem));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to cart')),
    );

    Navigator.of(context).pop();
  }
}
