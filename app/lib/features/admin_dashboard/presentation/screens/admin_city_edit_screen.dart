import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';

/// Edit a city name (office location label in the system).
class AdminCityEditScreen extends ConsumerStatefulWidget {
  const AdminCityEditScreen({super.key, required this.city});

  final CityResponse city;

  @override
  ConsumerState<AdminCityEditScreen> createState() => _AdminCityEditScreenState();
}

class _AdminCityEditScreenState extends ConsumerState<AdminCityEditScreen> {
  late final TextEditingController _name;
  late final TextEditingController _address;
  late final TextEditingController _contactPhone;
  late final TextEditingController _contactEmail;
  late final TextEditingController _workingHours;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.city.name ?? '');
    _address = TextEditingController(text: widget.city.address ?? '');
    _contactPhone = TextEditingController(text: widget.city.contactPhone ?? '');
    _contactEmail = TextEditingController(text: widget.city.contactEmail ?? '');
    _workingHours = TextEditingController(text: widget.city.workingHours ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _contactPhone.dispose();
    _contactEmail.dispose();
    _workingHours.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final id = widget.city.id;
    if (id == null) {
      setState(() => _error = 'Invalid city.');
      return;
    }
    final trimmed = _name.text.trim();
    if (trimmed.isEmpty) {
      setState(() => _error = 'Name is required.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(cityApiProvider).cityIdPut(
            id,
            cityUpsertRequest: CityUpsertRequest(
              name: trimmed,
              address: _address.text.trim().isEmpty ? null : _address.text.trim(),
              contactPhone: _contactPhone.text.trim().isEmpty ? null : _contactPhone.text.trim(),
              contactEmail: _contactEmail.text.trim().isEmpty ? null : _contactEmail.text.trim(),
              workingHours: _workingHours.text.trim().isEmpty ? null : _workingHours.text.trim(),
            ),
          );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit city')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('City ID: ${widget.city.id ?? '—'}'),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'City name',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _address,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contactPhone,
              decoration: const InputDecoration(
                labelText: 'Contact phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contactEmail,
              decoration: const InputDecoration(
                labelText: 'Contact email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _workingHours,
              decoration: const InputDecoration(
                labelText: 'Working hours',
                border: OutlineInputBorder(),
                hintText: 'Mon-Fri 08:00-16:00',
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
