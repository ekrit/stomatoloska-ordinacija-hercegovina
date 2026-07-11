import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/api_errors.dart';
import '../../../../core/widgets/paginated_search_view.dart';

/// CRUD za kategorije proizvoda (referentni podaci — rubrika 2.2).
class AdminProductCategoriesScreen extends ConsumerStatefulWidget {
  const AdminProductCategoriesScreen({super.key});

  @override
  ConsumerState<AdminProductCategoriesScreen> createState() =>
      _AdminProductCategoriesScreenState();
}

class _AdminProductCategoriesScreenState extends ConsumerState<AdminProductCategoriesScreen> {
  int _refresh = 0;

  void _reload() => setState(() => _refresh++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategorije proizvoda'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _reload, tooltip: 'Osvježi')],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        icon: const Icon(Icons.add),
        label: const Text('Dodaj kategoriju'),
      ),
      body: PaginatedSearchView<ProductCategoryResponse>(
        refreshKey: _refresh,
        searchHint: 'Pretraži kategorije…',
        emptyLabel: 'Nema pronađenih kategorija.',
        fetch: (query, page, pageSize) async {
          final r = await ref.read(productCategoryApiProvider).productCategoryGet(
                FTS: query.isEmpty ? null : query,
                page: page,
                pageSize: pageSize,
                includeTotalCount: true,
              );
          return PagedData(items: r?.items ?? [], total: r?.totalCount);
        },
        itemBuilder: (context, c) => ListTile(
          leading: const Icon(Icons.category_outlined),
          title: Text(c.name ?? 'Kategorija'),
          subtitle: (c.description ?? '').isNotEmpty ? Text(c.description!) : null,
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: c.id == null ? 'Brisanje nije moguće' : 'Obriši kategoriju',
            onPressed: c.id == null ? null : () => _confirmDelete(context, c),
          ),
          onTap: () => _openEditor(context, category: c),
        ),
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, {ProductCategoryResponse? category}) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _CategoryEditorDialog(category: category),
    );
    if (saved == true) _reload();
  }

  Future<void> _confirmDelete(BuildContext context, ProductCategoryResponse c) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Obrisati kategoriju?'),
        content: Text('Ukloniti kategoriju "${c.name ?? ''}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Odustani')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Obriši')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(productCategoryApiProvider).productCategoryIdDelete(c.id!);
      messenger.showSnackBar(
        SnackBar(content: Text('Kategorija "${c.name ?? ''}" je obrisana.')),
      );
      _reload();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(extractApiErrorMessage(e, fallback: 'Kategoriju nije moguće obrisati.'))),
      );
    }
  }
}

class _CategoryEditorDialog extends ConsumerStatefulWidget {
  const _CategoryEditorDialog({this.category});
  final ProductCategoryResponse? category;

  @override
  ConsumerState<_CategoryEditorDialog> createState() => _CategoryEditorDialogState();
}

class _CategoryEditorDialogState extends ConsumerState<_CategoryEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late bool _isActive;
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.category?.id != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.category?.name ?? '');
    _description = TextEditingController(text: widget.category?.description ?? '');
    _isActive = widget.category?.isActive ?? true;
  }

  @override
  void dispose() {
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
      final req = ProductCategoryUpsertRequest(
        name: _name.text.trim(),
        description: _description.text.trim(),
        isActive: _isActive,
      );
      final api = ref.read(productCategoryApiProvider);
      if (_isEditing) {
        await api.productCategoryIdPut(widget.category!.id!, productCategoryUpsertRequest: req);
      } else {
        await api.productCategoryPost(productCategoryUpsertRequest: req);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategorija "${_name.text.trim()}" je spašena.')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = extractApiErrorMessage(e, fallback: 'Kategoriju nije moguće spasiti.'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Uredi kategoriju' : 'Dodaj kategoriju'),
      content: SizedBox(
        width: 400,
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
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Aktivna'),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
            ],
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
