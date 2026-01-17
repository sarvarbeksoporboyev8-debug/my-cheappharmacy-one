import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:go_router/go_router.dart';
import 'package:sellingapp/core/auth.dart';
import 'package:sellingapp/nav.dart';

class LoginPage extends rp.ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  rp.ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends rp.ConsumerState<LoginPage> {
  final _name = TextEditingController(text: 'Alex Seller');
  final _email = TextEditingController(text: 'alex@example.com');
  final _form = GlobalKey<FormState>();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Welcome back', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Full name'), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
            const SizedBox(height: 12),
            TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress, validator: (v) => (v == null || !v.contains('@')) ? 'Invalid email' : null),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _loading
                  ? null
                  : () async {
                      if (!_form.currentState!.validate()) return;
                      setState(() => _loading = true);
                      try {
                        await ref.read(authStateProvider.notifier).login(name: _name.text.trim(), email: _email.text.trim());
                        if (mounted) context.go(AppRoutes.account);
                      } catch (e) {
                        debugPrint('Login failed: $e');
                      } finally {
                        if (mounted) setState(() => _loading = false);
                      }
                    },
              icon: const Icon(Icons.login, color: Colors.white),
              label: Text(_loading ? 'Signing in...' : 'Sign in'),
            ),
            const SizedBox(height: 8),
            Text('No backend connected. This is a local login stub.', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
