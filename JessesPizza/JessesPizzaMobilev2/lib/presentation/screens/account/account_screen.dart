import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/domain/models/user.dart';
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
  final User user;
  const _AuthenticatedView({required this.user});

  @override
  Widget build(BuildContext context) {
    final isGuest = user.isGuest;

    return ListView(
      children: [
        // Guest users get a "Log In / Sign Up" prompt at the top
        if (isGuest)
          ListTile(
            leading: const Icon(Icons.login, color: Colors.blue),
            title: const Text('Log In / Sign Up',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
          ),
        // Registered-only features
        if (!isGuest) ...[
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Order History'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('View Profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Manage Addresses'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddressesScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Manage Credit Cards'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CreditCardsScreen()),
            ),
          ),
        ],
        // Available to all users
        ListTile(
          leading: const Icon(Icons.contact_support),
          title: const Text('Contact Us'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ContactScreen()),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AboutScreen()),
          ),
        ),
        const Divider(),
        // No "Delete Account" for guests
        if (!isGuest)
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
            onTap: () => _confirmDeleteAccount(context),
          ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: Text(isGuest ? 'Exit Guest Mode' : 'Log Out'),
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

