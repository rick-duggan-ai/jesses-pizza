import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_state.dart';
import 'package:jesses_pizza_app/presentation/screens/menu/category_items_screen.dart';
import 'package:jesses_pizza_app/presentation/widgets/store_closed_banner.dart';

class MenuCategoriesScreen extends StatefulWidget {
  const MenuCategoriesScreen({super.key});

  @override
  State<MenuCategoriesScreen> createState() => _MenuCategoriesScreenState();
}

class _MenuCategoriesScreenState extends State<MenuCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MenuBloc>().add(const MenuEvent.loadMenu());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jesse's Pizza")),
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (categories, groups, isStoreOpen, _) {
              return Column(
                children: [
                  if (!isStoreOpen) const StoreClosedBanner(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return ListTile(
                          leading: category.imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: category.imageUrl!,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => const SizedBox(
                                      width: 56,
                                      height: 56,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2)),
                                    ),
                                    errorWidget: (_, __, ___) =>
                                        const Icon(Icons.fastfood, size: 40),
                                  ),
                                )
                              : const Icon(Icons.fastfood, size: 40),
                          title: Text(category.name),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    CategoryItemsScreen(category: category),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Unable to load menu. Please try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<MenuBloc>()
                          .add(const MenuEvent.loadMenu());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
