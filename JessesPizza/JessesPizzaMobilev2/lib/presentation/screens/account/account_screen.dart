import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_state.dart';
import 'package:jesses_pizza_app/presentation/screens/auth/login_screen.dart';
import 'package:jesses_pizza_app/presentation/screens/account/order_history_screen.dart';
import 'package:jesses_pizza_app/presentation/screens/account/profile_screen.dart';
import 'package:jesses_pizza_app/presentation/screens/account/addresses_screen.dart';
import 'package:jesses_pizza_app/presentation/screens/account/credit_cards_screen.dart';
import 'package:jesses_pizza_app/presentation/screens/account/contact_screen.dart';
import 'package:jesses_pizza_app/presentation/screens/account/about_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Account')),
          body: state is AuthAuthenticated
              ? _AuthenticatedView(user: state.user)
              : const _UnauthenticatedView(),
        );
      },
    );
  }
}

class _UnauthenticatedView extends StatelessWidget {
  const _UnauthenticatedView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Sign in to manage your account',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthenticatedView extends StatelessWidget {
  final dynamic user;
  const _AuthenticatedView({required this.user});

  @override
  Widget build(BuildContext context) {
    final items = <_SettingsItem>[
      _SettingsItem(
        title: 'Order History',
        icon: Icons.history,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
        ),
      ),
      _SettingsItem(
        title: 'View Profile',
        icon: Icons.person,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        ),
      ),
      _SettingsItem(
        title: 'Manage Addresses',
        icon: Icons.location_on,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddressesScreen()),
        ),
      ),
      _SettingsItem(
        title: 'Manage Credit Cards',
        icon: Icons.credit_card,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CreditCardsScreen()),
        ),
      ),
      _SettingsItem(
        title: 'Contact Us',
        icon: Icons.contact_support,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ContactScreen()),
        ),
      ),
      _SettingsItem(
        title: 'About',
        icon: Icons.info_outline,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AboutScreen()),
        ),
      ),
    ];

    return ListView(
      children: [
        ...items.map(
          (item) => ListTile(
            leading: Icon(item.icon),
            title: Text(item.title),
            trailing: const Icon(Icons.chevron_right),
            onTap: item.onTap,
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
          onTap: () => _confirmDeleteAccount(context),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Log Out'),
          onTap: () {
            context.read<AuthBloc>().add(const AuthEvent.logoutRequested());
          },
        ),
      ],
    );
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<AuthBloc>().add(const AuthEvent.deleteAccountRequested());
    }
  }
}

class _SettingsItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const _SettingsItem({required this.title, required this.icon, required this.onTap});
}
