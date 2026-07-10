import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
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

final _productCategoriesProvider =
    FutureProvider.autoDispose<List<ProductCategoryResponse>>((ref) async {
  final r = await ref.watch(productCategoryApiProvider).productCategoryGet(pageSize: 100);
  return r?.items ?? [];
});

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
  late final TextEditingController _price;
  int? _categoryId;
  String? _pictureBase64;
  Uint8List? _pictureBytes; // decoded once, never in build()
  bool _pictureUpdated = false;
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
    _price = TextEditingController(text: p?.price?.toString() ?? '');
    _categoryId = p?.productCategoryId;
    _pictureBase64 = p?.picture;
    _pictureBytes = _tryDecode(p?.picture);
    for (final c in [_name, _description, _price]) {
      c.addListener(() {
        if (!_dirty) setState(() => _dirty = true);
      });
    }
  }

  static Uint8List? _tryDecode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return base64Decode(raw);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    super.dispose();
  }

  Future<void> _pickPicture() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final bytes = result.files.single.bytes;
    if (bytes == null || bytes.isEmpty) return;
    setState(() {
      _pictureBytes = bytes;
      _pictureBase64 = base64Encode(bytes);
      _pictureUpdated = true;
      _dirty = true;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final categoryId = _categoryId;
    if (categoryId == null) {
      setState(() => _error = 'Pick a product category.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final request = ProductUpsertRequest(
        name: _name.text.trim(),
        description: _description.text.trim(),
        productCategoryId: categoryId,
        price: double.parse(_price.text.trim().replaceAll(',', '.')),
        picture: _pictureUpdated ? _pictureBase64 : widget.product?.picture,
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
    final categories = ref.watch(_productCategoriesProvider);
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
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _pictureBytes != null
                        ? Image.memory(_pictureBytes!, width: 72, height: 72, fit: BoxFit.cover)
                        : Container(
                            width: 72,
                            height: 72,
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            child: const Icon(Icons.image_outlined),
                          ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: _pickPicture,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Choose picture'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
              categories.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text(extractApiErrorMessage(e)),
                data: (list) => DropdownButtonFormField<int>(
                  value: list.any((c) => c.id == _categoryId) ? _categoryId : null,
                  decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                  items: list
                      .where((c) => c.id != null)
                      .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name ?? '')))
                      .toList(),
                  onChanged: (v) => setState(() {
                    _categoryId = v;
                    _dirty = true;
                  }),
                  validator: (v) => v == null ? 'Category is required.' : null,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _price,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Price (KM)', border: OutlineInputBorder()),
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
