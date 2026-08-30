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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context, null),
        icon: const Icon(Icons.add),
        label: const Text('Dodaj doktora'),
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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (d.rating != null) ...[
                const Icon(Icons.star, size: 18, color: Colors.amber),
                Text(d.rating!.toStringAsFixed(1)),
                const SizedBox(width: 8),
              ],
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Uredi',
                onPressed: () => _openEditor(context, d),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Obriši',
                onPressed: () => _confirmDelete(d),
              ),
            ],
          ),
          onTap: () => _openEditor(context, d),
        ),
      ),
    );
  }

  /// A null [doctor] opens the dialog in create mode.
  Future<void> _openEditor(BuildContext context, DoctorResponse? doctor) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _DoctorEditorDialog(doctor: doctor),
    );
    if (saved == true) _reload();
  }

  Future<void> _confirmDelete(DoctorResponse doctor) async {
    final id = doctor.userId;
    if (id == null) return;

    final name = '${doctor.firstName ?? ''} ${doctor.lastName ?? ''}'.trim();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Obrisati doktorski profil?'),
        content: Text(
          'Profil "$name" će biti obrisan. Korisnički nalog ostaje; '
          'ako postoje termini ili recenzije, server će odbiti brisanje.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Odustani')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Obriši')),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await ref.read(doctorApiProvider).doctorIdDelete(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Doktorski profil je obrisan.')),
      );
      _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(extractApiErrorMessage(e,
            fallback: 'Doktora nije moguće obrisati.'))),
      );
    }
  }
}

class _DoctorEditorDialog extends ConsumerStatefulWidget {
  const _DoctorEditorDialog({required this.doctor});

  /// Null when creating a new profile.
  final DoctorResponse? doctor;

  @override
  ConsumerState<_DoctorEditorDialog> createState() => _DoctorEditorDialogState();
}

class _DoctorEditorDialogState extends ConsumerState<_DoctorEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _specialization;
  late final TextEditingController _bio;
  bool _saving = false;
  String? _error;

  /// Create mode only: the account the new profile belongs to. A Doctor row is
  /// keyed by UserId, so it is always attached to an existing user.
  int? _userId;
  List<UserResponse> _users = const [];
  bool _loadingUsers = false;

  bool get _isEditing => widget.doctor?.userId != null;

  @override
  void initState() {
    super.initState();
    _specialization = TextEditingController(text: widget.doctor?.specialization ?? '');
    _bio = TextEditingController(text: widget.doctor?.bio ?? '');
    if (!_isEditing) _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _loadingUsers = true);
    try {
      final page = await ref.read(usersApiProvider).usersGet(pageSize: 100);
      final existing = await ref.read(doctorApiProvider).doctorGet(pageSize: 100);
      final taken = (existing?.items ?? [])
          .map((d) => d.userId)
          .whereType<int>()
          .toSet();
      if (!mounted) return;
      setState(() {
        // Only accounts without a profile yet: one Doctor row per user.
        _users = (page?.items ?? [])
            .where((u) => u.id != null && !taken.contains(u.id))
            .toList();
      });
    } catch (e) {
      if (mounted) {
        setState(() => _error = extractApiErrorMessage(e,
            fallback: 'Listu korisnika nije moguće učitati.'));
      }
    } finally {
      if (mounted) setState(() => _loadingUsers = false);
    }
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
    final targetUserId = _isEditing ? d!.userId : _userId;
    if (targetUserId == null) {
      setState(() => _error = 'Odaberite korisnika za doktorski profil.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      // The server owns the name (copied from the user account) and the
      // rating (earned from reviews); this form edits specialization and bio.
      final request = DoctorUpsertRequest(
        userId: targetUserId,
        firstName: d?.firstName ?? '',
        lastName: d?.lastName ?? '',
        specialization: _specialization.text.trim(),
        bio: _bio.text.trim().isEmpty ? null : _bio.text.trim(),
        rating: d?.rating ?? 0,
      );

      final api = ref.read(doctorApiProvider);
      if (_isEditing) {
        await api.doctorIdPut(targetUserId, doctorUpsertRequest: request);
      } else {
        await api.doctorPost(doctorUpsertRequest: request);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing
              ? 'Profil doktora je ažuriran.'
              : 'Doktorski profil je kreiran.'),
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
      title: Text(_isEditing
          ? 'Uredi profil — ${d!.firstName ?? ''} ${d.lastName ?? ''}'.trim()
          : 'Novi doktorski profil'),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isEditing) ...[
                if (_loadingUsers)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: LinearProgressIndicator(),
                  )
                else
                  DropdownButtonFormField<int>(
                    value: _userId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Korisnički nalog',
                      helperText: 'Doktorski profil se veže za postojeći nalog.',
                      border: OutlineInputBorder(),
                    ),
                    items: _users
                        .map((u) => DropdownMenuItem(
                              value: u.id,
                              child: Text(
                                '${u.firstName ?? ''} ${u.lastName ?? ''} (${u.username ?? ''})'.trim(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _userId = v),
                    validator: (v) => v == null ? 'Odaberite korisnika.' : null,
                  ),
                const SizedBox(height: 12),
              ],
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
