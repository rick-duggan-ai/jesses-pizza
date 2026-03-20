import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/domain/models/guest_info.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/cart/cart_event.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/delivery_mode_screen.dart';

class GuestInfoScreen extends StatefulWidget {
  const GuestInfoScreen({super.key});

  @override
  State<GuestInfoScreen> createState() => _GuestInfoScreenState();
}

class _GuestInfoScreenState extends State<GuestInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 10 || digitsOnly.length > 11) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validateZip(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Zip code is required';
    }
    final zipRegex = RegExp(r'^\d{5}(-\d{4})?$');
    if (!zipRegex.hasMatch(value.trim())) {
      return 'Enter a valid zip code';
    }
    return null;
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      final guestInfo = GuestInfo(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        addressLine1: _addressController.text.trim(),
        city: _cityController.text.trim(),
        zipCode: _zipController.text.trim(),
      );

      context.read<CartBloc>().add(SetGuestInfo(guestInfo));

      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const DeliveryModeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Information')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter your details',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (v) => _validateRequired(v, 'First name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (v) => _validateRequired(v, 'Last name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '(XXX) XXX-XXXX',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: _validatePhone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (v) => _validateRequired(v, 'Address'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (v) => _validateRequired(v, 'City'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _zipController,
                decoration: const InputDecoration(
                  labelText: 'Zip Code',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: _validateZip,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onContinue,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
