import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/domain/models/credit_card.dart';
import 'package:jesses_pizza_app/domain/models/transaction_request.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_state.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_state.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_state.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_state.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/hpp_webview_screen.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/order_confirmation_screen.dart';
import 'package:jesses_pizza_app/presentation/widgets/credit_card_tile.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  CreditCard? _selectedCard;

  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(const LoadCreditCards());
  }

  /// Builds a complete [TransactionRequest] matching V1's LocalTransactionV1_1
  /// format from the current cart state and authenticated user info.
  TransactionRequest _buildTransaction(CartState cartState) {
    // Get customer info from auth state
    final authState = context.read<AuthBloc>().state;
    final userEmail = authState is AuthAuthenticated
        ? authState.user.email ?? ''
        : '';
    final isGuest = authState is AuthAuthenticated && authState.user.isGuest;

    // Build customer info
    final customerInfo = CustomerInfo(
      firstName: isGuest ? 'Guest' : '',
      lastName: '',
      phoneNumber: '',
      emailAddress: userEmail,
      addressLine1: cartState.address?.addressLine1,
      city: cartState.address?.city,
      zipCode: cartState.address?.zipCode,
    );

    // Build order totals from cart
    final totals = OrderTotals(
      subTotal: cartState.total,
      total: cartState.total,
    );

    return TransactionRequest.fromCartState(
      items: cartState.items,
      customerInfo: customerInfo,
      totals: totals,
      isDelivery: cartState.isDelivery,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderSubmitted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (_) => const OrderConfirmationScreen()),
            (route) => route.isFirst,
          );
        } else if (state is HppTokenReady) {
          final nav = Navigator.of(context);
          nav.push<bool>(
            MaterialPageRoute(
              builder: (_) => HppWebviewScreen(tokenUrl: state.token),
            ),
          ).then((result) {
            if (result == true) {
              nav.push(
                MaterialPageRoute(builder: (_) => const OrderConfirmationScreen()),
              );
            }
          });
        } else if (state is OrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            return Column(
              children: [
                // Order summary
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Summary',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      ...cartState.items.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${item.name} (${item.sizeName}) x${item.quantity}'),
                                Text(
                                    '\$${item.lineTotal.toStringAsFixed(2)}'),
                              ],
                            ),
                          )),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          Text(
                            '\$${cartState.total.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Saved cards
                Expanded(
                  child: BlocBuilder<AccountBloc, AccountState>(
                    builder: (context, accountState) {
                      if (accountState is AccountLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final cards = accountState is AccountLoaded
                          ? accountState.creditCards
                          : <CreditCard>[];

                      if (cards.isEmpty) {
                        return const Center(
                          child: Text('No saved cards. Use "Pay with new card".'),
                        );
                      }

                      return ListView.builder(
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          final card = cards[index];
                          return CreditCardTile(
                            card: card,
                            selected: _selectedCard?.id == card.id,
                            onTap: () => setState(() => _selectedCard = card),
                          );
                        },
                      );
                    },
                  ),
                ),
                // Action buttons
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: BlocBuilder<OrderBloc, OrderState>(
                    builder: (context, orderState) {
                      final isLoading = orderState is OrderLoading;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: (_selectedCard == null || isLoading)
                                ? null
                                : () {
                                    final tx = _buildTransaction(cartState);
                                    final postRequest = PostTransactionRequest(
                                      transaction: tx,
                                      card: CreditCardRef(
                                        id: _selectedCard!.id,
                                      ),
                                    );
                                    context
                                        .read<OrderBloc>()
                                        .add(SubmitOrder(request: postRequest));
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Text('Pay with Selected Card'),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    final tx = _buildTransaction(cartState);
                                    context
                                        .read<OrderBloc>()
                                        .add(RequestHppToken(transaction: tx));
                                  },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Pay with New Card'),
                          ),
                        ],
                      );
                    },
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
