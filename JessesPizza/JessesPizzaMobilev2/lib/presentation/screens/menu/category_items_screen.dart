import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jesses_pizza_app/domain/models/menu_category.dart';
import 'package:jesses_pizza_app/presentation/screens/menu/item_detail_screen.dart';

class CategoryItemsScreen extends StatelessWidget {
  final MenuCategory category;

  const CategoryItemsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final categoryItems = category.menuItems;

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: categoryItems.isEmpty
          ? const Center(child: Text('No items in this category.'))
          : ListView.separated(
              itemCount: categoryItems.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = categoryItems[index];
                final startingPrice =
                    item.sizes.isNotEmpty ? item.sizes.first.price : null;
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ItemDetailScreen(item: item),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 128,
                            height: 128,
                            child: item.imageUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: item.imageUrl!,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => const Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                    errorWidget: (_, __, ___) => const Icon(
                                        Icons.local_pizza, size: 64),
                                  )
                                : const Icon(Icons.local_pizza, size: 64),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall),
                              if (startingPrice != null)
                                Text(
                                  'From \$${startingPrice.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
