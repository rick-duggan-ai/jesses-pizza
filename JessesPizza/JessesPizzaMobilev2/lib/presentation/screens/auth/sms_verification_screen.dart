import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/app/di.dart';
import 'package:jesses_pizza_app/domain/repositories/i_auth_repository.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/auth/auth_state.dart';
import 'package:jesses_pizza_app/presentation/screens/auth/login_screen.dart';
import 'package:jesses_pizza_app/presentation/screens/auth/new_password_screen.dart';

class SmsVerificationScreen extends StatefulWidget {
  /// Used for signup verification context.
  final String? email;
  /// Used for password_reset verification context.
  final String? phoneNumber;
  /// Either 'signup' or 'password_reset'
  final String verificationContext;

  const SmsVerificationScreen({
    super.key,
    this.email,
    this.phoneNumber,
    required this.verificationContext,
  });

  @override
  State<SmsVerificationScreen> createState() => _SmsVerificationScreenState();
}

class _SmsVerificationScreenState extends State<SmsVerificationScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _countdown = 0;
  Timer? _timer;
  bool _repoLoading = false;

  /// Display label: show phone number for password reset, email for signup.
  String get _recipientDisplay {
    if (widget.verificationContext == 'password_reset') {
      return widget.phoneNumber ?? '';
    }
    return widget.email ?? '';
  }

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() => _countdown = 30);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown <= 0) {
        t.cancel();
      } else {
        setState(() => _countdown--);
      }
    });
  }

  Future<void> _verify() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (widget.verificationContext == 'signup') {
      context.read<AuthBloc>().add(
            AuthEvent.confirmAccountRequested(
              email: widget.email!,
              code: _codeController.text.trim(),
            ),
          );
    } else {
      // password_reset: call repo directly
      setState(() => _repoLoading = true);
      try {
        final repo = getIt<IAuthRepository>();
        final code = _codeController.text.trim();
        await repo.confirmPasswordChange(widget.phoneNumber!, code);
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => NewPasswordScreen(phoneNumber: widget.phoneNumber!, token: code),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
          );
          setState(() => _repoLoading = false);
        }
      }
    }
  }

  Future<void> _resendCode() async {
    if (_countdown > 0) return;
    try {
      final repo = getIt<IAuthRepository>();
      if (widget.verificationContext == 'signup') {
        await repo.resendSignupCode(widget.email!);
      } else {
        await repo.resendChangePasswordCode(widget.phoneNumber!);
      }
      _startCountdown();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification code resent.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSignup = widget.verificationContext == 'signup';
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated && isSignup) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account confirmed! Please log in.')),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => route.isFirst,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isSignup ? 'Verify Account' : 'Verify Code'),
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading || _repoLoading;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.sms, size: 64, color: Colors.blue),
                    const SizedBox(height: 16),
                    Text(
                      'Enter the 6-digit code sent to\n$_recipientDisplay',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _codeController,
                      decoration: const InputDecoration(
                        labelText: 'Verification Code',
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 24, letterSpacing: 8),
                      validator: (v) {
                        if (v == null || v.length != 6) {
                          return 'Enter the 6-digit code';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading ? null : _verify,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Verify',
                              style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _countdown > 0 ? null : _resendCode,
                      child: Text(
                        _countdown > 0
                            ? 'Resend code in ${_countdown}s'
                            : 'Resend Code',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
