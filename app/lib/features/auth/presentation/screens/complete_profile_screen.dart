import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/router/app_routes.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
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
      setState(() => _error = 'Not signed in.');
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
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete patient profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'We need a few details to set up your patient record for appointments.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
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
                  controller: _phone,
                  decoration: const InputDecoration(labelText: 'Phone (optional)'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Date of birth'),
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
                      : const Text('Save and continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
