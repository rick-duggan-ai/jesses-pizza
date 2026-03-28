import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/data/services/signalr_service.dart';
import 'package:jesses_pizza_app/domain/models/credit_card.dart';
import 'package:jesses_pizza_app/domain/models/transaction_request.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_state.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_state.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_state.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/order/order_state.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/hpp_webview_screen.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/order_confirmation_screen.dart';
import 'package:jesses_pizza_app/presentation/widgets/credit_card_tile.dart';
import 'package:jesses_pizza_app/presentation/widgets/save_card_dialog.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  CreditCard? _selectedCard;

  bool get _isGuest {
    final authState = context.read<AuthBloc>().state;
    return authState is AuthAuthenticated && authState.user.isGuest;
  }

  @override
  void initState() {
    super.initState();
    if (!_isGuest) {
      context.read<AccountBloc>().add(const LoadCreditCards());
    }
  }

  TransactionRequest _buildTransactionRequest(CartState cartState) {
    final authState = context.read<AuthBloc>().state;
    CustomerInfo customerInfo;
    if (cartState.guestInfo != null) {
      final g = cartState.guestInfo!;
      customerInfo = CustomerInfo(
        firstName: g.firstName,
        lastName: g.lastName,
        phoneNumber: g.phoneNumber,
        emailAddress: g.email,
        addressLine1: g.addressLine1,
        city: g.city,
        zipCode: g.zipCode,
      );
    } else if (authState is AuthAuthenticated) {
      customerInfo = CustomerInfo(
        emailAddress: authState.user.email,
        addressLine1: cartState.address?.addressLine1,
        city: cartState.address?.city,
        zipCode: cartState.address?.zipCode,
      );
    } else {
      customerInfo = const CustomerInfo();
    }

    final totals = OrderTotals(
      subTotal: cartState.subtotal,
      taxTotal: cartState.taxAmount,
      deliveryCharge: cartState.deliveryAmount,
      tip: cartState.tip,
      total: cartState.total,
    );

    return TransactionRequest.fromCartState(
      items: cartState.items,
      customerInfo: customerInfo,
      totals: totals,
      isDelivery: cartState.isDelivery,
    );
  }

  void _navigateToOrderConfirmation(NavigatorState nav) {
    nav.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const OrderConfirmationScreen()),
      (route) => route.isFirst,
    );
  }

  Future<void> _handleHppApproval(
    NavigatorState nav,
    HppResult result,
  ) async {
    // Guests cannot save cards -- go straight to confirmation.
    if (_isGuest) {
      _navigateToOrderConfirmation(nav);
      return;
    }

    // Check if the card is already saved (from HPPApprovalMessage data).
    final isCardSaved = result.data?['IsCardSaved'] as bool? ?? false;
    if (isCardSaved) {
      _navigateToOrderConfirmation(nav);
      return;
    }

    // Extract card data from the HPP approval message.
    final cardData = result.data?['Card'] as Map<String, dynamic>?;
    if (cardData == null) {
      // No card data available -- skip save prompt.
      _navigateToOrderConfirmation(nav);
      return;
    }

    // Ask the user if they want to save the card.
    if (!mounted) return;
    final wantsSave = await SaveCardDialog.show(context);

    if (wantsSave && mounted) {
      try {
        final card = CreditCard.fromJson(cardData);
        context.read<AccountBloc>().add(SaveCard(card: card));
      } catch (_) {
        // If saving fails, still continue to confirmation.
      }
    }

    if (mounted) {
      _navigateToOrderConfirmation(nav);
    }
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
          final messenger = ScaffoldMessenger.of(context);
          nav.push<HppResult>(
            MaterialPageRoute(
              builder: (_) => HppWebviewScreen(
                tokenUrl: state.token,
                transactionGuid: state.transactionGuid,
              ),
            ),
          ).then((result) {
            if (result == null) return;
            switch (result.paymentResult) {
              case HppPaymentResult.approve:
                _handleHppApproval(nav, result);
              case HppPaymentResult.decline:
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(result.message ?? 'Card was declined'),
                    backgroundColor: Colors.red,
                  ),
                );
              case HppPaymentResult.cancel:
                // User cancelled -- stay on payment screen
                break;
              case HppPaymentResult.failed:
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(result.message ?? 'Payment failed'),
                    backgroundColor: Colors.red,
                  ),
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
                      _totalsRow('Subtotal', cartState.subtotal),
                      _totalsRow('Tax', cartState.taxAmount),
                      if (cartState.isDelivery)
                        _totalsRow('Delivery', cartState.deliveryAmount),
                      if (cartState.tip > 0)
                        _totalsRow('Tip', cartState.tip),
                      const SizedBox(height: 4),
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
                // Saved cards (hidden for guests)
                if (!_isGuest)
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
                  )
                else
                  const Expanded(
                    child: Center(
                      child: Text('Tap "Pay with New Card" to enter your card details.'),
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
                          if (!_isGuest) ...[
                            ElevatedButton(
                              onPressed: (_selectedCard == null || isLoading)
                                  ? null
                                  : () {
                                      final tx = _buildTransactionRequest(cartState);
                                      final postRequest = PostTransactionRequest(
                                        transaction: tx,
                                        card: CreditCardRef(id: _selectedCard!.id),
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
                          ],
                          OutlinedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    final tx = _buildTransactionRequest(cartState);
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

  Widget _totalsRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text('\$${amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
