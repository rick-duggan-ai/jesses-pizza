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
  late final bool _isGuest;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    _isGuest = authState is AuthAuthenticated && authState.user.isGuest;
    if (!_isGuest) {
      context.read<AccountBloc>().add(const LoadCreditCards());
    }
  }

  /// Builds a V1.1 [PostTransactionRequest] payload matching the C#
  /// PostTransactionRequestV1_1 / LocalTransactionV1_1 nested structure.
  Map<String, dynamic> _buildTransaction(CartState cartState,
      {CreditCardRef? card}) {
    // Resolve customer info from auth state or guest info
    final authState = context.read<AuthBloc>().state;
    final userEmail = authState is AuthAuthenticated
        ? authState.user.email ?? ''
        : '';
    final isGuest = authState is AuthAuthenticated && authState.user.isGuest;
    final guest = cartState.guestInfo;

    final customerInfo = CustomerInfo(
      firstName: guest?.firstName ?? (isGuest ? 'Guest' : ''),
      lastName: guest?.lastName ?? '',
      phoneNumber: guest?.phoneNumber ?? '',
      emailAddress: guest?.email ?? userEmail,
      addressLine1: guest?.addressLine1 ?? cartState.address?.addressLine1,
      city: guest?.city ?? cartState.address?.city,
      zipCode: guest?.zipCode ?? cartState.address?.zipCode,
    );

    // Compute order totals (mirrors C# OrderTotals)
    final subTotal = cartState.subtotal;
    final taxTotal = subTotal * cartState.taxRate;
    final deliveryAmt = cartState.isDelivery ? cartState.deliveryCharge : 0.0;
    final tip = cartState.tipAmount;
    final total = subTotal + taxTotal + deliveryAmt + tip;

    final totals = OrderTotals(
      subTotal: subTotal,
      taxTotal: taxTotal,
      deliveryCharge: deliveryAmt,
      tip: tip,
      total: total,
    );

    final transaction = TransactionRequest.fromCartState(
      items: cartState.items,
      customerInfo: customerInfo,
      totals: totals,
      isDelivery: cartState.isDelivery,
    );

    if (card != null) {
      return PostTransactionRequest(
        transaction: transaction,
        card: card,
      ).toJson();
    }
    // For HPP flow, send just the transaction (no card)
    return transaction.toJson();
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
                                    final tx = _buildTransaction(
                                      cartState,
                                      card: CreditCardRef(
                                        id: _selectedCard!.id,
                                      ),
                                    );
                                    context
                                        .read<OrderBloc>()
                                        .add(SubmitOrder(transaction: tx));
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
