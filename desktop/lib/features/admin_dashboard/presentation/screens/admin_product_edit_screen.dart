import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/api_errors.dart';

String? validateProductName(String value) {
  final v = value.trim();
  if (v.isEmpty) return 'Name is required.';
  if (v.length > 100) return 'Name must be 100 characters or less.';
  return null;
}

class AdminProductEditScreen extends ConsumerStatefulWidget {
  const AdminProductEditScreen({super.key, this.product});

  final ProductResponse? product;

  @override
  ConsumerState<AdminProductEditScreen> createState() => _AdminProductEditScreenState();
}

class _AdminProductEditScreenState extends ConsumerState<AdminProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _category;
  late final TextEditingController _price;
  bool _saving = false;
  bool _dirty = false;
  String? _error;

  bool get _isEdit => widget.product?.id != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _name = TextEditingController(text: p?.name ?? '');
    _description = TextEditingController(text: p?.description ?? '');
    _category = TextEditingController(text: p?.category ?? '');
    _price = TextEditingController(text: p?.price?.toString() ?? '');
    for (final c in [_name, _description, _category, _price]) {
      c.addListener(() {
        if (!_dirty) setState(() => _dirty = true);
      });
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _category.dispose();
    _price.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final request = ProductUpsertRequest(
        name: _name.text.trim(),
        description: _description.text.trim(),
        category: _category.text.trim(),
        price: double.parse(_price.text.trim().replaceAll(',', '.')),
      );
      if (_isEdit) {
        await ref.read(productApiProvider).productIdPut(widget.product!.id!, productUpsertRequest: request);
      } else {
        await ref.read(productApiProvider).productPost(productUpsertRequest: request);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = extractApiErrorMessage(e, fallback: 'Could not save the product.'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<bool> _confirmDiscard() async {
    if (!_dirty || _saving) return true;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('You have unsaved changes. Leave without saving?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep editing')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Discard')),
        ],
      ),
    );
    return ok ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (await _confirmDiscard() && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(_isEdit ? 'Edit product' : 'Add product')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                validator: (v) => validateProductName(v ?? ''),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _category,
                decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                validator: (v) => (v ?? '').trim().isEmpty ? 'Category is required.' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _price,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Price (EUR)', border: OutlineInputBorder()),
                validator: (v) {
                  final d = double.tryParse((v ?? '').trim().replaceAll(',', '.'));
                  if (d == null) return 'Enter a valid price.';
                  if (d <= 0) return 'Price must be greater than 0.';
                  return null;
                },
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
