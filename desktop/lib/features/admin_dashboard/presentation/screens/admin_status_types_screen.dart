import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/api/soh_extra_api.dart';
import '../../../../core/utils/api_errors.dart';

/// Administration for a status codebook (appointment or payment statuses).
///
/// The status values themselves are enums in code, because the state machine
/// depends on them — a status an administrator could delete out from under a
/// running transition would be worse than no codebook at all. What is
/// maintainable here is the label and description shown throughout the apps,
/// with full create / read / update / delete, and delete refused by the server
/// while any record still carries the status.
class AdminStatusTypesScreen extends ConsumerStatefulWidget {
  const AdminStatusTypesScreen({
    super.key,
    required this.title,
    required this.resource,
  });

  /// Screen heading.
  final String title;

  /// API resource segment: `AppointmentStatusType` or `PaymentStatusType`.
  final String resource;

  @override
  ConsumerState<AdminStatusTypesScreen> createState() => _AdminStatusTypesScreenState();
}

class _AdminStatusTypesScreenState extends ConsumerState<AdminStatusTypesScreen> {
  late Future<List<StatusTypeItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<StatusTypeItem>> _load() =>
      SohExtraApi(ref.read(apiClientProvider)).listStatusTypes(widget.resource);

  void _reload() => setState(() => _future = _load());

  Future<void> _openEditor({StatusTypeItem? item}) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _StatusTypeDialog(resource: widget.resource, item: item),
    );
    if (saved == true) _reload();
  }

  Future<void> _confirmDelete(StatusTypeItem item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Obrisati status?'),
        content: Text(
          'Status "${item.name}" (šifra ${item.id}) će biti obrisan iz šifarnika. '
          'Ako ga koristi ijedan zapis, server će odbiti brisanje.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Odustani')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Obriši')),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await SohExtraApi(ref.read(apiClientProvider))
          .deleteStatusType(widget.resource, item.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status je obrisan.')),
      );
      _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(extractApiErrorMessage(e,
            fallback: 'Status nije moguće obrisati.'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload, tooltip: 'Osvježi'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        icon: const Icon(Icons.add),
        label: const Text('Dodaj status'),
      ),
      body: FutureBuilder<List<StatusTypeItem>>(
        future: _future,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text(extractApiErrorMessage(snap.error!)));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snap.data!;
          if (items.isEmpty) {
            return const Center(child: Text('Šifarnik je prazan.'));
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final item = items[i];
              return ListTile(
                leading: CircleAvatar(child: Text('${item.id}')),
                title: Text(item.name),
                subtitle: Text(item.description ?? '—'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: 'Uredi',
                      onPressed: () => _openEditor(item: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Obriši',
                      onPressed: () => _confirmDelete(item),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _StatusTypeDialog extends ConsumerStatefulWidget {
  const _StatusTypeDialog({required this.resource, this.item});

  final String resource;
  final StatusTypeItem? item;

  @override
  ConsumerState<_StatusTypeDialog> createState() => _StatusTypeDialogState();
}

class _StatusTypeDialogState extends ConsumerState<_StatusTypeDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _id;
  late final TextEditingController _name;
  late final TextEditingController _description;
  bool _saving = false;
  String? _error;

  bool get _isNew => widget.item == null;

  @override
  void initState() {
    super.initState();
    _id = TextEditingController(text: widget.item?.id.toString() ?? '');
    _name = TextEditingController(text: widget.item?.name ?? '');
    _description = TextEditingController(text: widget.item?.description ?? '');
  }

  @override
  void dispose() {
    _id.dispose();
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await SohExtraApi(ref.read(apiClientProvider)).saveStatusType(
        widget.resource,
        id: int.parse(_id.text.trim()),
        name: _name.text.trim(),
        description: _description.text.trim().isEmpty ? null : _description.text.trim(),
        isNew: _isNew,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = extractApiErrorMessage(e, fallback: 'Status nije moguće spasiti.'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isNew ? 'Novi status' : 'Uredi status'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _id,
                // The id ties the row to its enum value, so it is fixed once set.
                enabled: _isNew,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Šifra',
                  helperText: 'Mora odgovarati vrijednosti statusa u kodu.',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final n = int.tryParse((v ?? '').trim());
                  if (n == null) return 'Šifra mora biti cijeli broj.';
                  if (n <= 0) return 'Šifra mora biti pozitivan broj.';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Naziv',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.isEmpty) return 'Naziv je obavezan.';
                  if (t.length > 50) return 'Naziv može imati najviše 50 znakova.';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Opis',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v ?? '').trim().length > 200
                    ? 'Opis može imati najviše 200 znakova.'
                    : null,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Odustani'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Spasi'),
        ),
      ],
    );
  }
}
