import 'package:flutter/material.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';

class AddressTile extends StatelessWidget {
  final Address address;
  final bool selected;
  final VoidCallback onTap;

  const AddressTile({
    super.key,
    required this.address,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: selected
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        leading: const Icon(Icons.location_on_outlined),
        title: Text(address.addressLine1),
        subtitle: Text('${address.city}, ${address.zipCode}'),
        trailing: selected
            ? Icon(Icons.check_circle,
                color: Theme.of(context).colorScheme.primary)
            : null,
        onTap: onTap,
      ),
    );
  }
}
