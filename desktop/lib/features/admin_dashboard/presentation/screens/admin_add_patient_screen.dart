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

  Future<void> _submit() async {
    final gid = _genderId;
    final cid = _cityId;
    if (gid == null || cid == null) {
      setState(() => _error = 'Please select gender and city.');
      return;
    }
    final first = _first.text.trim();
    final last = _last.text.trim();
    final email = _email.text.trim();
    final username = _username.text.trim();
    final password = _password.text;
    if (first.isEmpty || last.isEmpty) {
      setState(() => _error = 'First and last name are required.');
      return;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      setState(() => _error = 'Please enter a valid email address.');
      return;
    }
    if (username.length < 3) {
      setState(() => _error = 'Username must be at least 3 characters.');
      return;
    }
    if (password.length < 8) {
      setState(() => _error = 'Password must be at least 8 characters.');
      return;
    }
    if (_dob.isAfter(DateTime.now())) {
      setState(() => _error = 'Date of birth cannot be in the future.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final user = await ref.read(usersApiProvider).usersRegisterPost(
            userRegisterRequest: UserRegisterRequest(
              firstName: first,
              lastName: last,
              email: email,
              username: username,
              phoneNumber: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
              genderId: gid,
              cityId: cid,
              password: password,
            ),
          );
      final uid = user?.id;
      if (uid == null) {
        setState(() => _error = 'Registration did not return a user id.');
        return;
      }
      await ref.read(patientApiProvider).patientPost(
            patientUpsertRequest: PatientUpsertRequest(
              userId: uid,
              firstName: first,
              lastName: last,
              phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
              dateOfBirth: _dob,
            ),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patient account created.')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = extractApiErrorMessage(e,
          fallback: 'Could not create the patient account.'));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final genders = ref.watch(_gendersAddPatientProvider);
    final cities = ref.watch(_citiesAddPatientProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add patient')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Creates a login and patient profile. The new user can sign in with the username and password you set.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _first,
                  decoration: const InputDecoration(labelText: 'First name'),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _last,
                  decoration: const InputDecoration(labelText: 'Last name'),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _username,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _phone,
                  decoration: const InputDecoration(labelText: 'Phone (optional)'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: _pickDob,
                  child: Text('Date of birth: ${_dob.year}-${_dob.month.toString().padLeft(2, '0')}-${_dob.day.toString().padLeft(2, '0')}'),
                ),
                const SizedBox(height: 8),
                genders.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Genders: $e'),
                  data: (list) {
                    return DropdownButtonFormField<int>(
                      value: _genderId,
                      decoration: const InputDecoration(labelText: 'Gender'),
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
                  error: (e, _) => Text('Cities: $e'),
                  data: (list) {
                    return DropdownButtonFormField<int>(
                      value: _cityId,
                      decoration: const InputDecoration(labelText: 'City'),
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
                TextField(
                  controller: _password,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                      : const Text('Create patient'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
