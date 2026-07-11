import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/api_errors.dart';
import '../../../../core/widgets/paginated_search_view.dart';

/// Uređivanje profila doktora (specijalizacija i biografija). Korisnički
/// nalozi doktora (e-mail, uloge…) uređuju se na ekranu korisnika.
class AdminDoctorsListScreen extends ConsumerStatefulWidget {
  const AdminDoctorsListScreen({super.key});

  @override
  ConsumerState<AdminDoctorsListScreen> createState() => _AdminDoctorsListScreenState();
}

class _AdminDoctorsListScreenState extends ConsumerState<AdminDoctorsListScreen> {
  int _refresh = 0;

  void _reload() => setState(() => _refresh++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doktori'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _reload, tooltip: 'Osvježi')],
      ),
      body: PaginatedSearchView<DoctorResponse>(
        refreshKey: _refresh,
        searchHint: 'Pretraži po imenu ili specijalizaciji…',
        emptyLabel: 'Nema pronađenih doktora.',
        fetch: (query, page, pageSize) async {
          final r = await ref.read(doctorApiProvider).doctorGet(
                FTS: query.isEmpty ? null : query,
                page: page,
                pageSize: pageSize,
                includeTotalCount: true,
              );
          return PagedData(items: r?.items ?? [], total: r?.totalCount);
        },
        itemBuilder: (context, d) => ListTile(
          leading: const CircleAvatar(child: Icon(Icons.medical_services_outlined)),
          title: Text('${d.firstName ?? ''} ${d.lastName ?? ''}'.trim()),
          subtitle: Text(
            [
              if ((d.specialization ?? '').isNotEmpty) d.specialization!,
              if ((d.bio ?? '').trim().isNotEmpty) d.bio!.trim(),
            ].join(' · '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: d.rating != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 18, color: Colors.amber),
                    Text(d.rating!.toStringAsFixed(1)),
                  ],
                )
              : null,
          onTap: () => _openEditor(context, d),
        ),
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, DoctorResponse doctor) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _DoctorEditorDialog(doctor: doctor),
    );
    if (saved == true) _reload();
  }
}

class _DoctorEditorDialog extends ConsumerStatefulWidget {
  const _DoctorEditorDialog({required this.doctor});
  final DoctorResponse doctor;

  @override
  ConsumerState<_DoctorEditorDialog> createState() => _DoctorEditorDialogState();
}

class _DoctorEditorDialogState extends ConsumerState<_DoctorEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _specialization;
  late final TextEditingController _bio;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _specialization = TextEditingController(text: widget.doctor.specialization ?? '');
    _bio = TextEditingController(text: widget.doctor.bio ?? '');
  }

  @override
  void dispose() {
    _specialization.dispose();
    _bio.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final d = widget.doctor;
    if (d.userId == null) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(doctorApiProvider).doctorIdPut(
            d.userId!,
            doctorUpsertRequest: DoctorUpsertRequest(
              userId: d.userId!,
              firstName: d.firstName ?? '',
              lastName: d.lastName ?? '',
              specialization: _specialization.text.trim(),
              bio: _bio.text.trim().isEmpty ? null : _bio.text.trim(),
              rating: d.rating ?? 0,
            ),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profil doktora ${d.firstName ?? ''} ${d.lastName ?? ''} je ažuriran.'.trim(),
          ),
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = extractApiErrorMessage(e, fallback: 'Profil nije moguće spasiti.'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.doctor;
    return AlertDialog(
      title: Text('Uredi profil — ${d.firstName ?? ''} ${d.lastName ?? ''}'.trim()),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _specialization,
                decoration: const InputDecoration(
                  labelText: 'Specijalizacija',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v ?? '').trim().isEmpty ? 'Specijalizacija je obavezna.' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bio,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Biografija (opcionalno)',
                  helperText: 'Kratak opis vidljiv pacijentima u aplikaciji.',
                  border: OutlineInputBorder(),
                ),
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
