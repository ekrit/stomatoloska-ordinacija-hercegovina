import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/api_errors.dart';
import '../../../../core/widgets/paginated_search_view.dart';

class AdminGendersListScreen extends ConsumerStatefulWidget {
  const AdminGendersListScreen({super.key});

  @override
  ConsumerState<AdminGendersListScreen> createState() => _AdminGendersListScreenState();
}

class _AdminGendersListScreenState extends ConsumerState<AdminGendersListScreen> {
  int _refresh = 0;

  void _reload() => setState(() => _refresh++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spolovi'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _reload)],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        icon: const Icon(Icons.add),
        label: const Text('Dodaj spol'),
      ),
      body: PaginatedSearchView<GenderResponse>(
        refreshKey: _refresh,
        searchHint: 'Pretraži spolove…',
        emptyLabel: 'Nema pronađenih spolova.',
        fetch: (query, page, pageSize) async {
          final r = await ref.read(genderApiProvider).genderGet(
                FTS: query.isEmpty ? null : query,
                page: page,
                pageSize: pageSize,
                includeTotalCount: true,
              );
          return PagedData(items: r?.items ?? [], total: r?.totalCount);
        },
        itemBuilder: (context, g) => ListTile(
          leading: const Icon(Icons.wc_outlined),
          title: Text(g.name ?? 'Gender #${g.id ?? ''}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Obriši',
            onPressed: g.id == null ? null : () => _confirmDelete(context, g),
          ),
          onTap: () => _openEditor(context, gender: g),
        ),
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, {GenderResponse? gender}) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _GenderEditorDialog(gender: gender),
    );
    if (saved == true) _reload();
  }

  Future<void> _confirmDelete(BuildContext context, GenderResponse g) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Obrisati spol?'),
        content: Text('Remove "${g.name ?? 'this gender'}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Odustani')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Obriši')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(genderApiProvider).genderIdDelete(g.id!);
      _reload();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(extractApiErrorMessage(e, fallback: 'Spol nije moguće obrisati.'))),
      );
    }
  }
}

class _GenderEditorDialog extends ConsumerStatefulWidget {
  const _GenderEditorDialog({this.gender});
  final GenderResponse? gender;

  @override
  ConsumerState<_GenderEditorDialog> createState() => _GenderEditorDialogState();
}

class _GenderEditorDialogState extends ConsumerState<_GenderEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.gender?.id != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.gender?.name ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final req = GenderUpsertRequest(name: _name.text.trim());
      final api = ref.read(genderApiProvider);
      if (_isEditing) {
        await api.genderIdPut(widget.gender!.id!, genderUpsertRequest: req);
      } else {
        await api.genderPost(genderUpsertRequest: req);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = extractApiErrorMessage(e, fallback: 'Spol nije moguće spasiti.'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Uredi spol' : 'Dodaj spol'),
      content: SizedBox(
        width: 360,
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Naziv', border: OutlineInputBorder()),
            validator: (v) => (v ?? '').trim().isEmpty ? 'Naziv je obavezan.' : null,
          ),
        ),
      ),
      actions: [
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
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
