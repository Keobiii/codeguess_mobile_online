import 'package:codeguess/features/authentication/presentation/notifiers/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:codeguess/core/theme/app_theme.dart';
// Adjust these two imports to where your widgets live
import 'package:codeguess/features/widget/outline_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../widget/outline_textfield.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authControllerProvider.notifier)
        .signIn(_emailController.text.trim(), _passwordController.text);

    // context.push('/');
  }

  @override
  Widget build(BuildContext context) {
    // Show auth errors as a snackbar
    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('${next.error}')));
      }
    });

    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome back',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.text,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Log in to keep your records',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.secondaryText),
                    ),
                    const SizedBox(height: 32),
                    OutlineTextfield(
                      controller: _emailController,
                      hintText: 'Email',
                      enabled: !isLoading,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return 'Email is required';
                        if (!text.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    OutlineTextfield(
                      controller: _passwordController,
                      hintText: 'Password',
                      enabled: !isLoading,
                      isPassword: true,
                      autofillHints: const [AutofillHints.password],
                      onSubmitted: (_) => _submit(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : OutlineButton(text: 'Log In', onPressed: _submit),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: AppTheme.secondaryText),
                        ),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () => context.push('/register'),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: AppTheme.text,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
