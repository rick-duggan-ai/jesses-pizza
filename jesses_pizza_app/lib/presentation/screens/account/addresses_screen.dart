import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/account/account_state.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(const AccountEvent.loadAddresses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Addresses')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAddressDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AccountLoaded) {
            final addresses = state.addresses;
            if (addresses.isEmpty) {
              return const Center(child: Text('No saved addresses.'));
            }
            return ListView.separated(
              itemCount: addresses.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final address = addresses[index];
                return ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(address.addressLine1),
                  subtitle: Text(
                    '${address.city}, ${address.state ?? ''} ${address.zipCode}'.trim(),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context
                          .read<AccountBloc>()
                          .add(AccountEvent.deleteAddress(address: address));
                    },
                  ),
                );
              },
            );
          } else if (state is AccountError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _showAddAddressDialog(BuildContext context) async {
    final line1Controller = TextEditingController();
    final line2Controller = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final zipController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Address'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: line1Controller,
                  decoration: const InputDecoration(labelText: 'Address Line 1'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                  controller: line2Controller,
                  decoration: const InputDecoration(labelText: 'Address Line 2 (optional)'),
                ),
                TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                  controller: stateController,
                  decoration: const InputDecoration(labelText: 'State'),
                ),
                TextFormField(
                  controller: zipController,
                  decoration: const InputDecoration(labelText: 'Zip Code'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final address = Address(
                  addressLine1: line1Controller.text,
                  addressLine2: line2Controller.text.isEmpty ? null : line2Controller.text,
                  city: cityController.text,
                  state: stateController.text.isEmpty ? null : stateController.text,
                  zipCode: zipController.text,
                );
                context.read<AccountBloc>().add(AccountEvent.saveAddress(address: address));
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
