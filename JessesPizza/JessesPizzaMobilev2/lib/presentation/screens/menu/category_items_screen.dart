import 'package:flutter/material.dart';
import 'package:jesses_pizza_app/domain/models/menu_category.dart';
import 'package:jesses_pizza_app/presentation/screens/menu/item_detail_screen.dart';
import 'package:jesses_pizza_app/presentation/widgets/menu_item_card.dart';

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
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: categoryItems.length,
              itemBuilder: (context, index) {
                final item = categoryItems[index];
                return MenuItemCard(
                  item: item,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ItemDetailScreen(item: item),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
