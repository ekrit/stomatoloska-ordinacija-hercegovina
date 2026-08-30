import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/api_errors.dart';

final _gendersAddPatientProvider = FutureProvider.autoDispose<List<GenderResponse>>((ref) async {
  final r = await ref.watch(genderApiProvider).genderGet(pageSize: 100);
  return r?.items ?? [];
});

final _citiesAddPatientProvider = FutureProvider.autoDispose<List<CityResponse>>((ref) async {
  final r = await ref.watch(cityApiProvider).cityGet(pageSize: 100);
  return r?.items ?? [];
});

/// Admin flow: register a user account and create the linked patient record.
class AdminAddPatientScreen extends ConsumerStatefulWidget {
  const AdminAddPatientScreen({super.key});

  @override
  ConsumerState<AdminAddPatientScreen> createState() => _AdminAddPatientScreenState();
}

class _AdminAddPatientScreenState extends ConsumerState<AdminAddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  int? _genderId;
  int? _cityId;
  DateTime _dob = DateTime(1990, 1, 1);
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

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  String? _required(String? v, String field) =>
      (v ?? '').trim().isEmpty ? '$field je obavezno polje.' : null;

  String? _validateEmail(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return 'E-mail je obavezno polje.';
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t)
        ? null
        : 'Unesite validnu e-mail adresu (npr. ime@example.com).';
  }

  String? _validateUsername(String? v) =>
      (v ?? '').trim().length < 3 ? 'Korisničko ime mora imati najmanje 3 znaka.' : null;

  String? _validatePhone(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return null;
    return RegExp(r'^[+0-9\s().-]{6,20}$').hasMatch(t)
        ? null
        : 'Unesite validan telefon (cifre, razmaci, +, -, zagrade).';
  }

  String? _validatePassword(String? v) =>
      (v ?? '').length < 8 ? 'Lozinka mora imati najmanje 8 znakova.' : null;

  Future<void> _submit() async {
    // Each rule is now attached to its own field, so the admin sees which
    // input is wrong rather than one shared line at the bottom of the form.
    if (!_formKey.currentState!.validate()) return;

    final gid = _genderId;
    final cid = _cityId;
    if (gid == null || cid == null) {
      setState(() => _error = 'Odaberite spol i grad.');
      return;
    }
    final first = _first.text.trim();
    final last = _last.text.trim();
    final email = _email.text.trim();
    final username = _username.text.trim();
    final password = _password.text;

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // One call, one transaction: /Users/register creates the account, its
      // Patient role and the linked chart together. The old flow followed it
      // with POST /Patient for the same UserId, which duplicated the create
      // the server had already done.
      await ref.read(usersApiProvider).usersRegisterPost(
            userRegisterRequest: UserRegisterRequest(
              firstName: first,
              lastName: last,
              email: email,
              username: username,
              phoneNumber: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
              genderId: gid,
              cityId: cid,
              password: password,
              dateOfBirth: _dob,
            ),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pacijentski nalog je kreiran.')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = extractApiErrorMessage(e,
          fallback: 'Pacijentski nalog nije moguće kreirati.'));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final genders = ref.watch(_gendersAddPatientProvider);
    final cities = ref.watch(_citiesAddPatientProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dodaj pacijenta')),
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
                Text(
                  'Kreira nalog i pacijentski karton. Novi korisnik se prijavljuje '
                  'korisničkim imenom i lozinkom koje ovdje postavite.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
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
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _username,
                  decoration: const InputDecoration(labelText: 'Korisničko ime'),
                  validator: _validateUsername,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phone,
                  decoration: const InputDecoration(labelText: 'Telefon (opcionalno)'),
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone,
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: _pickDob,
                  child: Text('Datum rođenja: ${_dob.year}-${_dob.month.toString().padLeft(2, '0')}-${_dob.day.toString().padLeft(2, '0')}'),
                ),
                const SizedBox(height: 8),
                genders.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text(extractApiErrorMessage(e, fallback: 'Spolove nije moguće učitati.')),
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
                    );
                  },
                ),
                const SizedBox(height: 8),
                cities.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text(extractApiErrorMessage(e, fallback: 'Gradove nije moguće učitati.')),
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
                    );
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _password,
                  obscureText: _obscure,
                  validator: _validatePassword,
                  decoration: InputDecoration(
                    labelText: 'Lozinka',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
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
                      : const Text('Kreiraj pacijenta'),
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
