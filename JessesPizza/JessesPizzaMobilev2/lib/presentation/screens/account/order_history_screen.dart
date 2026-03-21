import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_state.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_state.dart';
import 'package:jesses_pizza_app/presentation/widgets/order_tile.dart';
import 'package:jesses_pizza_app/presentation/screens/account/order_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    final isGuest =
        authState is AuthAuthenticated && authState.user.isGuest;
    if (isGuest) {
      context
          .read<OrderBloc>()
          .add(const OrderEvent.loadGuestOrderHistory());
    } else {
      context.read<OrderBloc>().add(const OrderEvent.loadOrderHistory());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryLoaded) {
            final orders = state.orders;
            if (orders.isEmpty) {
              return const Center(
                child: Text('No orders yet.'),
              );
            }
            return ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderTile(
                  order: order,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OrderDetailScreen(order: order),
                    ),
                  ),
                );
              },
            );
          } else if (state is OrderError) {
            return Center(child: Text('Error: \${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
