import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          Icon(Icons.local_pizza, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            "Jesse's Pizza",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Version 1.0.0',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          Text(
            "Jesse's Pizza has been serving the community with fresh, handcrafted pizzas "
            'since 1985. Our app makes it easy to order your favorite pies for delivery or '
            'pickup right from your phone.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          Divider(),
          SizedBox(height: 16),
          Text(
            'Built with Flutter',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
