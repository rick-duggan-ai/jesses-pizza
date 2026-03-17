import 'package:flutter/material.dart';

class MenuCategoriesScreen extends StatelessWidget {
  const MenuCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jesse's Pizza")),
      body: const Center(child: Text('Menu')),
    );
  }
}
