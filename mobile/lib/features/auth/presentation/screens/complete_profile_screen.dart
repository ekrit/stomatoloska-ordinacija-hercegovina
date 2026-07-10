import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/api_errors.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _phone = TextEditingController();
  DateTime _dob = DateTime(1990, 1, 1);
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _phone.dispose();
    super.dispose();
  }

  String? _required(String? raw, String field) {
    final v = (raw ?? '').trim();
    return v.isEmpty ? '$field je obavezno polje.' : null;
  }

  String? _validatePhone(String? raw) {
    final v = (raw ?? '').trim();
    if (v.isEmpty) return null; // optional
    final ok = RegExp(r'^[+0-9\s().-]{6,20}$').hasMatch(v);
    return ok
        ? null
        : 'Unesite validan telefon (cifre, razmaci, +, -, zagrade; 6-20 znakova).';
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

  Future<void> _save() async {
    final user = ref.read(currentUserProvider);
    if (user?.id == null) {
      setState(() => _error = 'Niste prijavljeni.');
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    if (_dob.isAfter(DateTime.now())) {
      setState(() => _error = 'Datum rođenja ne može biti u budućnosti.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(patientApiProvider).patientPost(
            patientUpsertRequest: PatientUpsertRequest(
              userId: user!.id!,
              firstName: _first.text.trim(),
              lastName: _last.text.trim(),
              phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
              dateOfBirth: _dob,
            ),
          );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.patientShell);
    } catch (e) {
      setState(() => _error = extractApiErrorMessage(e,
          fallback: 'Profil nije moguće spasiti. Pokušajte ponovo.'));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dopuna pacijentskog profila')),
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
                    'Trebamo još nekoliko podataka da kreiramo vaš pacijentski karton za termine.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
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
                    controller: _phone,
                    decoration: const InputDecoration(
                      labelText: 'Telefon (opcionalno)',
                      helperText: 'Npr. +387 61 123 456',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: _validatePhone,
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Datum rođenja'),
                    subtitle: Text(MaterialLocalizations.of(context).formatFullDate(_dob)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _pickDob,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _loading ? null : _save,
                    child: _loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Spasi i nastavi'),
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
