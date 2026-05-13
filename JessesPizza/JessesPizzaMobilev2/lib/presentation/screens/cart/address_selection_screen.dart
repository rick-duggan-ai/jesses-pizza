import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/app/di.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/repositories/i_account_repository.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_state.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_event.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/payment_screen.dart';
import 'package:jesses_pizza_app/presentation/widgets/address_tile.dart';

class AddressSelectionScreen extends StatefulWidget {
  const AddressSelectionScreen({super.key});

  @override
  State<AddressSelectionScreen> createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(const LoadAddresses());
  }

  void _showAddAddressDialog(BuildContext context) {
    final addressLine1Controller = TextEditingController();
    final cityController = TextEditingController();
    final zipController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        bool isLoading = false;
        String? error;
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
                title: const Text('Add New Address'),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(error!,
                                style: const TextStyle(color: Colors.red)),
                          ),
                        TextFormField(
                          controller: addressLine1Controller,
                          decoration: const InputDecoration(labelText: 'Address Line 1'),
                          textCapitalization: TextCapitalization.words,
                          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: cityController,
                          decoration: const InputDecoration(labelText: 'City'),
                          textCapitalization: TextCapitalization.words,
                          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: zipController,
                          decoration: const InputDecoration(labelText: 'Zip Code'),
                          keyboardType: TextInputType.number,
                          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: isLoading ? null : () => Navigator.of(ctx).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (!(formKey.currentState?.validate() ?? false)) return;
                            setDialogState(() {
                              isLoading = true;
                              error = null;
                            });
                            final address = Address(
                              addressLine1: addressLine1Controller.text.trim(),
                              city: cityController.text.trim(),
                              zipCode: zipController.text.trim(),
                            );
                            try {
                              final repo = getIt<IAccountRepository>();
                              final result = await repo.saveAddress(address);
                              if (!result.succeeded) {
                                throw Exception(result.message ?? 'Failed to save address');
                              }
                              if (ctx.mounted) Navigator.of(ctx).pop();
                              if (context.mounted) {
                                context.read<AccountBloc>().add(const LoadAddresses());
                                context.read<CartBloc>().add(SetAddress(address));
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const PaymentScreen()),
                                );
                              }
                            } catch (e) {
                              setDialogState(() {
                                isLoading = false;
                                error = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
                              });
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Address')),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final addresses = state is AccountLoaded ? state.addresses : <Address>[];

          if (addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No saved addresses'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddAddressDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Address'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return AddressTile(
                      address: address,
                      onTap: () {
                        context
                            .read<CartBloc>()
                            .add(SetAddress(address));
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const PaymentScreen()),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: () => _showAddAddressDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Address'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
