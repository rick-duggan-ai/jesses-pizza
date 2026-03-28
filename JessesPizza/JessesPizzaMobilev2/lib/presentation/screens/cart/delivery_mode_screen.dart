import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_state.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_state.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/address_selection_screen.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/guest_info_screen.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/payment_screen.dart';

class DeliveryModeScreen extends StatelessWidget {
  const DeliveryModeScreen({super.key});

  void _selectPickup(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isGuest =
        authState is AuthAuthenticated && authState.user.isGuest;
    context.read<CartBloc>().add(const SetDeliveryMode(false));
    if (isGuest) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const GuestInfoScreen()),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const PaymentScreen()),
      );
    }
  }

  void _selectDelivery(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isGuest =
        authState is AuthAuthenticated && authState.user.isGuest;
    context.read<CartBloc>().add(const SetDeliveryMode(true));
    if (isGuest) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const GuestInfoScreen()),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => const AddressSelectionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Mode')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          final deliveryDisabled = cartState.isDeliveryDisabled;
          final meetsMinimum = cartState.meetsDeliveryMinimum;
          final deliveryEnabled = !deliveryDisabled && meetsMinimum;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'How would you like to receive your order?',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (deliveryDisabled)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Delivery is currently unavailable',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (!deliveryDisabled &&
                    !meetsMinimum &&
                    cartState.minimumOrderAmount > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Minimum order for delivery is \$${cartState.minimumOrderAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 16),
                _ModeButton(
                  icon: Icons.storefront,
                  label: 'Pickup',
                  subtitle: 'Pick up at the store',
                  onTap: () => _selectPickup(context),
                ),
                const SizedBox(height: 16),
                Opacity(
                  opacity: deliveryEnabled ? 1.0 : 0.5,
                  child: _ModeButton(
                    icon: Icons.delivery_dining,
                    label: 'Delivery',
                    subtitle: deliveryDisabled
                        ? 'Delivery is currently unavailable'
                        : 'Deliver to your address',
                    onTap: deliveryEnabled
                        ? () => _selectDelivery(context)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Opacity(
                  opacity: deliveryEnabled ? 1.0 : 0.5,
                  child: _ModeButton(
                    icon: Icons.door_front_door,
                    label: 'No Contact Delivery',
                    subtitle: deliveryDisabled
                        ? 'Delivery is currently unavailable'
                        : 'Leave at the door',
                    onTap: deliveryEnabled
                        ? () => _selectDelivery(context)
                        : null,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback? onTap;

  const _ModeButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.outline, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(label, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
