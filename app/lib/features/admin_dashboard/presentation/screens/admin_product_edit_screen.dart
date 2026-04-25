import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';

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
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _category;
  late final TextEditingController _price;
  bool _saving = false;
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
    final nameError = validateProductName(_name.text);
    final parsedPrice = double.tryParse(_price.text.trim());
    if (nameError != null) {
      setState(() => _error = nameError);
      return;
    }
    if (parsedPrice == null || parsedPrice <= 0) {
      setState(() => _error = 'Price must be a number greater than 0.');
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
        category: _category.text.trim(),
        price: parsedPrice,
      );
      if (_isEdit) {
        await ref.read(productApiProvider).productIdPut(
              widget.product!.id!,
              productUpsertRequest: request,
            );
      } else {
        await ref.read(productApiProvider).productPost(productUpsertRequest: request);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit product' : 'Add product')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _description,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _category,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _price,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Price',
              border: OutlineInputBorder(),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
    );
  }
}
