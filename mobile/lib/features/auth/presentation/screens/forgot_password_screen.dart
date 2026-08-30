import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/api/soh_extra_api.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/api_errors.dart';

/// Password reset for a user who cannot sign in.
///
/// Distinct from the change-password screen, which needs the current password
/// and an active session. Here the user proves control of the account's inbox
/// instead: they request a one-time code, which the server mails out, and set a
/// new password with it.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _requestFormKey = GlobalKey<FormState>();
  final _completeFormKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _code = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _codeSent = false;
  bool _loading = false;
  bool _obscure = true;
  String? _error;
  String? _info;

  @override
  void dispose() {
    _identifier.dispose();
    _code.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  SohExtraApi get _api => SohExtraApi(ref.read(apiClientProvider));

  Future<void> _requestCode() async {
    if (!_requestFormKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
      _info = null;
    });
    try {
      await _api.requestPasswordReset(_identifier.text.trim());
      if (!mounted) return;
      setState(() {
        _codeSent = true;
        // Deliberately neutral: the server does not say whether the account
        // exists, and neither should this screen.
        _info = 'Ako nalog postoji, kod za reset je poslan na e-mail adresu '
            'vezanu za taj nalog. Kod vrijedi 15 minuta.';
      });
    } catch (e) {
      setState(() => _error = extractApiErrorMessage(e,
          fallback: 'Zahtjev nije moguće poslati. Pokušajte ponovo.'));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _completeReset() async {
    if (!_completeFormKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
      _info = null;
    });
    try {
      await _api.completePasswordReset(
        usernameOrEmail: _identifier.text.trim(),
        code: _code.text.trim(),
        newPassword: _newPassword.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lozinka je promijenjena. Prijavite se.')),
      );
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    } catch (e) {
      setState(() => _error = extractApiErrorMessage(e,
          fallback: 'Lozinku nije moguće promijeniti. Pokušajte ponovo.'));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _validateIdentifier(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return 'Unesite korisničko ime ili e-mail.';
    return null;
  }

  String? _validateCode(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return 'Unesite kod iz e-maila.';
    if (!RegExp(r'^\d{6}$').hasMatch(t)) return 'Kod se sastoji od 6 cifara.';
    return null;
  }

  String? _validateNewPassword(String? v) {
    if ((v ?? '').length < 8) return 'Lozinka mora imati najmanje 8 znakova.';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v != _newPassword.text) return 'Lozinke se ne podudaraju.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zaboravljena lozinka')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Form(
                    key: _requestFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Unesite korisničko ime ili e-mail vezan za vaš nalog.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _identifier,
                          enabled: !_loading,
                          decoration: const InputDecoration(
                            labelText: 'Korisničko ime ili e-mail',
                            border: OutlineInputBorder(),
                          ),
                          validator: _validateIdentifier,
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: _loading ? null : _requestCode,
                          child: Text(_codeSent ? 'Pošalji kod ponovo' : 'Pošalji kod'),
                        ),
                      ],
                    ),
                  ),
                  if (_info != null) ...[
                    const SizedBox(height: 16),
                    Text(_info!, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                  if (_codeSent) ...[
                    const Divider(height: 32),
                    Form(
                      key: _completeFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _code,
                            enabled: !_loading,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Kod iz e-maila',
                              helperText: '6 cifara.',
                              border: OutlineInputBorder(),
                            ),
                            validator: _validateCode,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _newPassword,
                            enabled: !_loading,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              labelText: 'Nova lozinka',
                              helperText: 'Najmanje 8 znakova.',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => _obscure = !_obscure),
                                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                              ),
                            ),
                            validator: _validateNewPassword,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _confirmPassword,
                            enabled: !_loading,
                            obscureText: _obscure,
                            decoration: const InputDecoration(
                              labelText: 'Potvrdite novu lozinku',
                              border: OutlineInputBorder(),
                            ),
                            validator: _validateConfirm,
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _loading ? null : _completeReset,
                            child: _loading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text('Postavi novu lozinku'),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () => Navigator.of(context).pushReplacementNamed(AppRoutes.login),
                    child: const Text('Nazad na prijavu'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
