import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/api_errors.dart';

/// Add or edit an office location.
///
/// The form previously sent only the name, so the address, contact phone,
/// contact e-mail and working hours that `City` and `CityUpsertRequest` carry
/// could never be entered — even though editing exactly those is what the
/// project proposal describes. Every stored field is editable here.
class AdminCityEditScreen extends ConsumerStatefulWidget {
  const AdminCityEditScreen({super.key, this.city});

  final CityResponse? city;

  @override
  ConsumerState<AdminCityEditScreen> createState() => _AdminCityEditScreenState();
}

class _AdminCityEditScreenState extends ConsumerState<AdminCityEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _address;
  late final TextEditingController _contactPhone;
  late final TextEditingController _contactEmail;
  late final TextEditingController _workingHours;
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.city?.id != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.city?.name ?? '');
    _address = TextEditingController(text: widget.city?.address ?? '');
    _contactPhone = TextEditingController(text: widget.city?.contactPhone ?? '');
    _contactEmail = TextEditingController(text: widget.city?.contactEmail ?? '');
    _workingHours = TextEditingController(text: widget.city?.workingHours ?? '');
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

  String? _orNull(TextEditingController c) {
    final t = c.text.trim();
    return t.isEmpty ? null : t;
  }

  String? _validateName(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return 'Naziv lokacije je obavezan.';
    if (t.length > 50) return 'Naziv može imati najviše 50 znakova.';
    return null;
  }

  String? _validatePhone(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return null;
    final ok = RegExp(r'^[+0-9\s().-]{6,50}$').hasMatch(t);
    return ok ? null : 'Unesite validan telefon (cifre, razmaci, +, -, zagrade).';
  }

  String? _validateEmail(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return null;
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(t);
    return ok ? null : 'Unesite validnu e-mail adresu (npr. info@example.com).';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final request = CityUpsertRequest(
        name: _name.text.trim(),
        address: _orNull(_address),
        contactPhone: _orNull(_contactPhone),
        contactEmail: _orNull(_contactEmail),
        workingHours: _orNull(_workingHours),
      );
      final api = ref.read(cityApiProvider);
      if (_isEditing) {
        await api.cityIdPut(widget.city!.id!, cityUpsertRequest: request);
      } else {
        await api.cityPost(cityUpsertRequest: request);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = extractApiErrorMessage(e, fallback: 'Lokaciju nije moguće spasiti.'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Uredi lokaciju' : 'Dodaj lokaciju')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: 'Naziv lokacije',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: _validateName,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _address,
                  decoration: const InputDecoration(
                    labelText: 'Adresa',
                    hintText: 'Npr. Fra Anđela Zvizdovića 1',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v ?? '').trim().length > 200
                      ? 'Adresa može imati najviše 200 znakova.'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contactPhone,
                  decoration: const InputDecoration(
                    labelText: 'Kontakt telefon',
                    hintText: 'Npr. +387 33 123 456',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contactEmail,
                  decoration: const InputDecoration(
                    labelText: 'Kontakt e-mail',
                    hintText: 'Npr. info@ordinacija.ba',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _workingHours,
                  decoration: const InputDecoration(
                    labelText: 'Radno vrijeme',
                    hintText: 'Npr. Pon-Pet 08:00-18:00',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v ?? '').trim().length > 100
                      ? 'Radno vrijeme može imati najviše 100 znakova.'
                      : null,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Spasi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
