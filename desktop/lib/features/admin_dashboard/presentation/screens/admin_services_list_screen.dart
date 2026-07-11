import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/api_errors.dart';
import '../../../../core/widgets/paginated_search_view.dart';

class AdminServicesListScreen extends ConsumerStatefulWidget {
  const AdminServicesListScreen({super.key});

  @override
  ConsumerState<AdminServicesListScreen> createState() => _AdminServicesListScreenState();
}

class _AdminServicesListScreenState extends ConsumerState<AdminServicesListScreen> {
  int _refresh = 0;

  void _reload() => setState(() => _refresh++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usluge'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _reload)],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        icon: const Icon(Icons.add),
        label: const Text('Dodaj uslugu'),
      ),
      body: PaginatedSearchView<ServiceResponse>(
        refreshKey: _refresh,
        searchHint: 'Pretraži usluge…',
        emptyLabel: 'Nema pronađenih usluga.',
        fetch: (query, page, pageSize) async {
          final r = await ref.read(serviceApiProvider).serviceGet(
                FTS: query.isEmpty ? null : query,
                page: page,
                pageSize: pageSize,
                includeTotalCount: true,
              );
          return PagedData(items: r?.items ?? [], total: r?.totalCount);
        },
        itemBuilder: (context, s) => ListTile(
          title: Text(s.name ?? 'Service #${s.id ?? ''}'),
          subtitle: Text(
            '${s.price?.toStringAsFixed(2) ?? '0.00'} EUR · ${s.durationMinutes ?? 0} min'
            '${(s.description ?? '').isNotEmpty ? '\n${s.description}' : ''}',
          ),
          isThreeLine: (s.description ?? '').isNotEmpty,
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Obriši',
            onPressed: s.id == null ? null : () => _confirmDelete(context, s),
          ),
          onTap: () => _openEditor(context, service: s),
        ),
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, {ServiceResponse? service}) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _ServiceEditorDialog(service: service),
    );
    if (saved == true) _reload();
  }

  Future<void> _confirmDelete(BuildContext context, ServiceResponse s) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Obrisati uslugu?'),
        content: Text('Remove "${s.name ?? 'this service'}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Odustani')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Obriši')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(serviceApiProvider).serviceIdDelete(s.id!);
      _reload();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(extractApiErrorMessage(e, fallback: 'Uslugu nije moguće obrisati.'))),
      );
    }
  }
}

class _ServiceEditorDialog extends ConsumerStatefulWidget {
  const _ServiceEditorDialog({this.service});
  final ServiceResponse? service;

  @override
  ConsumerState<_ServiceEditorDialog> createState() => _ServiceEditorDialogState();
}

class _ServiceEditorDialogState extends ConsumerState<_ServiceEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _price;
  late final TextEditingController _duration;
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.service?.id != null;

  @override
  void initState() {
    super.initState();
    final s = widget.service;
    _name = TextEditingController(text: s?.name ?? '');
    _description = TextEditingController(text: s?.description ?? '');
    _price = TextEditingController(text: s?.price?.toStringAsFixed(2) ?? '');
    _duration = TextEditingController(text: s?.durationMinutes?.toString() ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    _duration.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final req = ServiceUpsertRequest(
        name: _name.text.trim(),
        description: _description.text.trim(),
        price: double.parse(_price.text.trim().replaceAll(',', '.')),
        durationMinutes: int.parse(_duration.text.trim()),
      );
      final api = ref.read(serviceApiProvider);
      if (_isEditing) {
        await api.serviceIdPut(widget.service!.id!, serviceUpsertRequest: req);
      } else {
        await api.servicePost(serviceUpsertRequest: req);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = extractApiErrorMessage(e, fallback: 'Uslugu nije moguće spasiti.'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Uredi uslugu' : 'Dodaj uslugu'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Naziv', border: OutlineInputBorder()),
                validator: (v) => (v ?? '').trim().isEmpty ? 'Naziv je obavezan.' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Opis', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _price,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Cijena (KM)', border: OutlineInputBorder()),
                validator: (v) {
                  final d = double.tryParse((v ?? '').trim().replaceAll(',', '.'));
                  if (d == null) return 'Unesite validnu cijenu.';
                  if (d < 0) return 'Cijena ne može biti negativna.';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _duration,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Trajanje (minute)', border: OutlineInputBorder()),
                validator: (v) {
                  final n = int.tryParse((v ?? '').trim());
                  if (n == null) return 'Unesite cijeli broj minuta.';
                  if (n <= 0) return 'Trajanje mora biti pozitivno.';
                  return null;
                },
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
        TextButton(onPressed: _saving ? null : () => Navigator.pop(context, false), child: const Text('Odustani')),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Spasi'),
        ),
      ],
    );
  }
}
