import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../patient/presentation/providers/patient_repository_providers.dart';
import '../../../../core/storage/auth_storage.dart';
import '../../../../core/utils/role_utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _showPassword = false;
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final session = ref.read(patientSessionRepositoryProvider);
      final response = await session.authenticate(
        UserLoginRequest(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        ),
      );
      final token = response?.token;
      if (token == null || token.isEmpty) {
        setState(() => _error = 'No token returned.');
        return;
      }
      ref.read(authTokenProvider.notifier).state = token;
      final user = response?.user;
      if (user != null) {
        ref.read(currentUserProvider.notifier).state = user;
        await AuthStorage.saveSession(token: token, user: user);
      } else {
        await AuthStorage.saveSession(token: token, user: null);
      }

      if (!mounted) return;

      if (user != null && userIsAdmin(user)) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.admin);
        return;
      }
      if (user != null && userIsDoctor(user)) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.doctor);
        return;
      }

      if (user?.id != null) {
        final existing =
            await session.listPatientsByUserId(user!.id!);
        final hasPatient = existing.isNotEmpty;
        if (!hasPatient) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.completeProfile);
          return;
        }
      }

      Navigator.of(context).pushReplacementNamed(AppRoutes.patientShell);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Stomatološka Ordinacija Hercegovina',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Book visits, view records, and stay on top of your oral health.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    autofillHints: const [AutofillHints.password],
                    onSubmitted: (_) => _loading ? null : _login(),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _loading ? null : _login,
                    child: _loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Sign in'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _loading
                        ? null
                        : () => Navigator.pushNamed(context, AppRoutes.register),
                    child: const Text('Create account'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () => Navigator.pushNamed(context, AppRoutes.guest),
                    child: const Text('Continue as guest — clinic locations only'),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
