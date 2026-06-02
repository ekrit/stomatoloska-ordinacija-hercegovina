import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/api_errors.dart';

/// Add or edit a city (office location label in the system).
class AdminCityEditScreen extends ConsumerStatefulWidget {
  const AdminCityEditScreen({super.key, this.city});

  final CityResponse? city;

  @override
  ConsumerState<AdminCityEditScreen> createState() => _AdminCityEditScreenState();
}

class _AdminCityEditScreenState extends ConsumerState<AdminCityEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.city?.id != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.city?.name ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final trimmed = _name.text.trim();
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final api = ref.read(cityApiProvider);
      if (_isEditing) {
        await api.cityIdPut(widget.city!.id!, cityUpsertRequest: CityUpsertRequest(name: trimmed));
      } else {
        await api.cityPost(cityUpsertRequest: CityUpsertRequest(name: trimmed));
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = extractApiErrorMessage(e, fallback: 'Could not save the city.'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit city' : 'Add city')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'City name',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.isEmpty) return 'City name is required.';
                  if (t.length < 2) return 'City name is too short.';
                  return null;
                },
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
      ),
    );
  }
}
