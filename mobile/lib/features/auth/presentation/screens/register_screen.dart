import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/api_errors.dart';

final _gendersRegisterProvider = FutureProvider.autoDispose<List<GenderResponse>>((ref) async {
  final r = await ref.watch(genderApiProvider).genderGet(pageSize: 100);
  return r?.items ?? [];
});

final _citiesRegisterProvider = FutureProvider.autoDispose<List<CityResponse>>((ref) async {
  final r = await ref.watch(cityApiProvider).cityGet(pageSize: 100);
  return r?.items ?? [];
});

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  int? _genderId;
  int? _cityId;
  bool _loading = false;
  String? _error;
  bool _obscure = true;

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _email.dispose();
    _username.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _required(String? raw, String field) {
    final v = (raw ?? '').trim();
    return v.isEmpty ? '$field je obavezno polje.' : null;
  }

  String? _validateEmail(String? raw) {
    final v = (raw ?? '').trim();
    if (v.isEmpty) return 'E-mail je obavezno polje.';
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v);
    return ok ? null : 'Unesite validnu e-mail adresu (npr. ime@example.com).';
  }

  String? _validateUsername(String? raw) {
    final v = (raw ?? '').trim();
    if (v.length < 3) return 'Korisničko ime mora imati najmanje 3 znaka.';
    return null;
  }

  String? _validatePhone(String? raw) {
    final v = (raw ?? '').trim();
    if (v.isEmpty) return null; // optional
    final ok = RegExp(r'^[+0-9\s().-]{6,20}$').hasMatch(v);
    return ok
        ? null
        : 'Unesite validan telefon (cifre, razmaci, +, -, zagrade; 6-20 znakova).';
  }

  String? _validatePassword(String? raw) {
    if ((raw ?? '').length < 8) return 'Lozinka mora imati najmanje 8 znakova.';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final gid = _genderId;
    final cid = _cityId;
    if (gid == null || cid == null) {
      setState(() => _error = 'Odaberite spol i grad.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(usersApiProvider).usersRegisterPost(
            userRegisterRequest: UserRegisterRequest(
              firstName: _first.text.trim(),
              lastName: _last.text.trim(),
              email: _email.text.trim(),
              username: _username.text.trim(),
              phoneNumber: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
              genderId: gid,
              cityId: cid,
              password: _password.text,
            ),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nalog je kreiran. Prijavite se.')),
      );
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    } catch (e) {
      setState(() => _error = extractApiErrorMessage(e,
          fallback: 'Registracija nije uspjela. Pokušajte ponovo.'));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final genders = ref.watch(_gendersRegisterProvider);
    final cities = ref.watch(_citiesRegisterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Registracija')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _first,
                    decoration: const InputDecoration(labelText: 'Ime'),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => _required(v, 'Ime'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _last,
                    decoration: const InputDecoration(labelText: 'Prezime'),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => _required(v, 'Prezime'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      helperText: 'Format: ime@example.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _username,
                    decoration: const InputDecoration(
                      labelText: 'Korisničko ime',
                      helperText: 'Najmanje 3 znaka.',
                    ),
                    validator: _validateUsername,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phone,
                    decoration: const InputDecoration(
                      labelText: 'Telefon (opcionalno)',
                      helperText: 'Npr. +387 61 123 456',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: _validatePhone,
                  ),
                  const SizedBox(height: 8),
                  genders.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text(extractApiErrorMessage(e)),
                    data: (list) {
                      return DropdownButtonFormField<int>(
                        value: _genderId,
                        decoration: const InputDecoration(labelText: 'Spol'),
                        items: list
                            .where((g) => g.id != null)
                            .map(
                              (g) => DropdownMenuItem(
                                value: g.id,
                                child: Text(g.name ?? '—'),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _genderId = v),
                        validator: (v) => v == null ? 'Odaberite spol.' : null,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  cities.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text(extractApiErrorMessage(e)),
                    data: (list) {
                      return DropdownButtonFormField<int>(
                        value: _cityId,
                        decoration: const InputDecoration(labelText: 'Grad'),
                        items: list
                            .where((c) => c.id != null)
                            .map(
                              (c) => DropdownMenuItem(
                                value: c.id,
                                child: Text(c.name ?? '—'),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _cityId = v),
                        validator: (v) => v == null ? 'Odaberite grad.' : null,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _password,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'Lozinka',
                      helperText: 'Najmanje 8 znakova.',
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ],
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Registruj se'),
                  ),
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () => Navigator.of(context).pushReplacementNamed(AppRoutes.login),
                    child: const Text('Već imate nalog? Prijavite se'),
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
