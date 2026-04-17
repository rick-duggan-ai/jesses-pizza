import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/domain/models/store_settings.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_state.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_state.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_state.dart';
import 'package:jesses_pizza_app/presentation/screens/auth/login_screen.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/delivery_mode_screen.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/guest_info_screen.dart';
import 'package:jesses_pizza_app/presentation/widgets/cart_item_tile.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _checkoutInProgress = false;

  /// Format an ISO 8601 or "HH:mm" time string to 12-hour (e.g. "11:00 AM").
  static String _formatTime(String time) {
    final dt = DateTime.tryParse(time);
    final hour = dt?.hour ?? int.tryParse(time.split(':').first) ?? 0;
    final minute = (dt?.minute ?? int.tryParse(time.split(':').elementAtOrNull(1) ?? '') ?? 0)
        .toString()
        .padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour == 0 ? 12 : hour > 12 ? hour - 12 : hour;
    return '$hour12:$minute $period';
  }

  void _showStoreClosedDialog(BuildContext context, StoreSettings settings) {
    final todayHours = settings.todayHours();

    String message;
    if (todayHours != null &&
        todayHours.openingTime != null &&
        todayHours.closingTime != null) {
      final open = _formatTime(todayHours.openingTime!);
      final close = _formatTime(todayHours.closingTime!);
      message = 'Sorry, we are currently closed. Today\'s hours are $open - $close.';
    } else {
      message = 'Sorry, we are currently closed for today.';
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Store Closed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _validateCartAgainstMenu(BuildContext context) {
    final menuState = context.read<MenuBloc>().state;
    if (menuState is! MenuLoaded) return;
    final validIds = <String>{};
    for (final category in menuState.categories) {
      for (final item in category.menuItems) {
        if (item.id != null) validIds.add(item.id!);
      }
    }
    final cartState = context.read<CartBloc>().state;
    final staleCount =
        cartState.items.where((i) => !validIds.contains(i.menuItemId)).length;
    if (staleCount > 0) {
      context.read<CartBloc>().add(ValidateCart(validIds));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$staleCount item${staleCount > 1 ? 's' : ''} removed (no longer on menu)',
          ),
        ),
      );
    }
  }

  void _proceedToCheckout(BuildContext context) {
    if (_checkoutInProgress) return;
    setState(() => _checkoutInProgress = true);

    void resetFlag() {
      if (mounted) setState(() => _checkoutInProgress = false);
    }

    final menuState = context.read<MenuBloc>().state;
    if (menuState is MenuLoaded && !menuState.isStoreOpen) {
      _showStoreClosedDialog(context, menuState.settings);
      resetFlag();
      return;
    }

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      if (authState.user.isGuest) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const GuestInfoScreen()),
        ).then((_) => resetFlag());
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DeliveryModeScreen()),
        ).then((_) => resetFlag());
      }
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Login Required'),
          content: const Text('Please log in or continue as guest to proceed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('Log In'),
            ),
          ],
        ),
      ).then((_) => resetFlag());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuBloc, MenuState>(
      listener: (context, state) {
        if (state is MenuLoaded) {
          _validateCartAgainstMenu(context);
        }
      },
      child: Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            final count = cartState.items.length;
            return Text(count > 0 ? 'Cart ($count)' : 'Cart');
          },
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    return CartItemTile(item: state.items[index], index: index);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total',
                            style: Theme.of(context).textTheme.titleLarge),
                        Text(
                          '\$${state.total.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _checkoutInProgress ? null : () => _proceedToCheckout(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _checkoutInProgress
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Proceed to Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      ),
    );
  }
}
