import 'package:flutter/material.dart';

class StoreClosedBanner extends StatelessWidget {
  const StoreClosedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.red.shade700,
      padding: const EdgeInsets.all(12),
      child: const Text(
        'Store is currently closed',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
