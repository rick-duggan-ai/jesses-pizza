import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
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
          SizedBox(height: 32),
          _ContactItem(icon: Icons.phone, label: 'Phone', value: '(555) 123-4567'),
          Divider(),
          _ContactItem(
            icon: Icons.location_on,
            label: 'Address',
            value: '123 Main Street\nAnytown, USA 12345',
          ),
          Divider(),
          _ContactItem(
            icon: Icons.email,
            label: 'Email',
            value: 'contact@jessespizza.com',
          ),
          Divider(),
          _ContactItem(
            icon: Icons.access_time,
            label: 'Hours',
            value: 'Mon–Thu: 11am–9pm\nFri–Sat: 11am–10pm\nSun: 12pm–8pm',
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.red),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
