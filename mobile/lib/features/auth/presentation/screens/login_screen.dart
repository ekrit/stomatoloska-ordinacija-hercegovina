import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../patient/presentation/providers/patient_repository_providers.dart';
import '../../../../core/storage/auth_storage.dart';
import '../../../../core/utils/api_errors.dart';
import '../../../../core/utils/role_utils.dart';

/// Patient mobile login. Staff accounts (Administrator / Doctor) are rejected
/// with a clear message pointing them to the desktop app.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
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

  String? _validateUsername(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return 'Korisničko ime je obavezno.';
    return null;
  }

  String? _validatePassword(String? v) {
    if ((v ?? '').isEmpty) return 'Lozinka je obavezna.';
    return null;
  }

  Future<void> _login() async {
    // Per-field validation, so an empty username no longer surfaces as the
    // same generic "wrong username or password" line as a real auth failure.
    if (!_formKey.currentState!.validate()) return;
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
        setState(() => _error = 'Server nije vratio token.');
        return;
      }

      final user = response?.user;

      // Administrators manage the clinic from the desktop app; the mobile
      // app serves patients and doctors.
      if (user != null && userIsAdmin(user)) {
        setState(() => _error =
            'Ovaj nalog je administratorski. Prijavite se putem desktop aplikacije.');
        return;
      }

      ref.read(authTokenProvider.notifier).state = token;
      if (user != null) {
        ref.read(currentUserProvider.notifier).state = user;
        await AuthStorage.saveSession(token: token, user: user);
      } else {
        await AuthStorage.saveSession(token: token, user: null);
      }

      if (!mounted) return;

      if (userIsDoctor(user)) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.doctorShell);
        return;
      }

      // No patient-chart probe here any more: registration and the admin
      // "add patient" flow both create the User and its Patient row in one
      // server-side transaction, so a signed-in patient always has a chart.
      // The old fallback sent them to a screen that POSTed to an
      // administrator-only endpoint, which could never succeed.
      Navigator.of(context).pushReplacementNamed(AppRoutes.patientShell);
    } catch (e) {
      setState(() => _error =
          extractApiErrorMessage(e, fallback: 'Pogrešno korisničko ime ili lozinka.'));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prijava')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
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
                    'Zakažite posjete, pregledajte nalaze i vodite računa o oralnom zdravlju.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 28),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Korisničko ime'),
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    validator: _validateUsername,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      labelText: 'Lozinka',
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
                    validator: _validatePassword,
                    onFieldSubmitted: (_) => _loading ? null : _login(),
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
                        : const Text('Prijava'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _loading
                        ? null
                        : () => Navigator.pushNamed(context, AppRoutes.register),
                    child: const Text('Kreiraj nalog'),
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    child: const Text('Zaboravili ste lozinku?'),
                  ),
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () => Navigator.pushNamed(context, AppRoutes.guest),
                    child: const Text('Nastavi kao gost — samo lokacije ordinacija'),
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
      ),
    );
  }
}
