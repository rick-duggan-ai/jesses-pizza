import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:jesses_pizza_app/domain/models/store_settings.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_state.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  static const _phone = '702-898-5635';
  static const _addressLine1 = '1450 W Horizon Ridge Pkwy #C-201';
  static const _addressLine2 = 'Henderson, NV 89012';
  static const _fullAddress = '$_addressLine1\n$_addressLine2';

  static const _dayNames = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('assets/images/logo.png', width: 80, height: 80),
          ),
          const SizedBox(height: 16),
          const Text(
            "Jesse's Pizza",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _TappableContactItem(
            icon: Icons.phone,
            label: 'Phone',
            value: _phone,
            onTap: () => _launchPhone(),
          ),
          const Divider(),
          _TappableContactItem(
            icon: Icons.location_on,
            label: 'Address',
            value: _fullAddress,
            onTap: () => _launchMaps(),
          ),
          const Divider(),
          const _ContactItem(
            icon: Icons.access_time,
            label: 'Hours',
            child: _StoreHoursSection(),
          ),
        ],
      ),
    );
  }

  static Future<void> _launchPhone() async {
    final uri = Uri(scheme: 'tel', path: _phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static Future<void> _launchMaps() async {
    final query = Uri.encodeComponent('$_addressLine1, $_addressLine2');
    final uri = Uri.parse('https://maps.apple.com/?q=$query');
    // Try Apple Maps first, fall back to Google Maps
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      final googleUri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$query');
      if (await canLaunchUrl(googleUri)) {
        await launchUrl(googleUri, mode: LaunchMode.externalApplication);
      }
    }
  }

  /// Format a 24-hour time string (e.g. "11:00") to 12-hour (e.g. "11:00 AM").
  static String _formatTime(String time24) {
    final parts = time24.split(':');
    if (parts.length < 2) return time24;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour == 0
        ? 12
        : hour > 12
            ? hour - 12
            : hour;
    return '$hour12:$minute $period';
  }
}

class _StoreHoursSection extends StatelessWidget {
  const _StoreHoursSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        if (state is MenuLoaded) {
          final hours = state.settings.storeHours;
          if (hours.isEmpty) {
            return const Text(
              'Hours not available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            );
          }
          return _buildHoursTable(hours);
        }
        // Loading or other states
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildHoursTable(List<StoreHours> hours) {
    // Build a map from API day number to StoreHours
    final hoursMap = <int, StoreHours>{};
    for (final h in hours) {
      hoursMap[h.day] = h;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(7, (index) {
        // API: 0 = Sunday, 1 = Monday, ... 6 = Saturday
        final dayHours = hoursMap[index];
        final dayName = ContactScreen._dayNames[index];
        final timeText = dayHours != null &&
                dayHours.openingTime != null &&
                dayHours.closingTime != null
            ? '${ContactScreen._formatTime(dayHours.openingTime!)} - ${ContactScreen._formatTime(dayHours.closingTime!)}'
            : 'Closed';

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dayName,
                  style: const TextStyle(fontSize: 15)),
              Text(timeText,
                  style: const TextStyle(fontSize: 15)),
            ],
          ),
        );
      }),
    );
  }
}

class _TappableContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _TappableContactItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
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
                  Text(label,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;

  const _ContactItem({
    required this.icon,
    required this.label,
    required this.child,
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
                Text(label,
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
