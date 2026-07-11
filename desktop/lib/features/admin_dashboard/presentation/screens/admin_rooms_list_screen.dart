import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/api_errors.dart';
import '../../../../core/widgets/paginated_search_view.dart';

class AdminRoomsListScreen extends ConsumerStatefulWidget {
  const AdminRoomsListScreen({super.key});

  @override
  ConsumerState<AdminRoomsListScreen> createState() => _AdminRoomsListScreenState();
}

class _AdminRoomsListScreenState extends ConsumerState<AdminRoomsListScreen> {
  int _refresh = 0;

  void _reload() => setState(() => _refresh++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prostorije'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _reload)],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        icon: const Icon(Icons.add),
        label: const Text('Dodaj prostoriju'),
      ),
      body: PaginatedSearchView<RoomResponse>(
        refreshKey: _refresh,
        searchHint: 'Pretraži prostorije…',
        emptyLabel: 'Nema pronađenih prostorija.',
        fetch: (query, page, pageSize) async {
          final r = await ref.read(roomApiProvider).roomGet(
                FTS: query.isEmpty ? null : query,
                page: page,
                pageSize: pageSize,
                includeTotalCount: true,
              );
          return PagedData(items: r?.items ?? [], total: r?.totalCount);
        },
        itemBuilder: (context, room) => ListTile(
          leading: Icon(
            room.isAvailable == true ? Icons.meeting_room_outlined : Icons.no_meeting_room_outlined,
            color: room.isAvailable == true ? Colors.green : Colors.grey,
          ),
          title: Text(room.name ?? 'Room #${room.id ?? ''}'),
          subtitle: Text(room.isAvailable == true ? 'Dostupna' : 'Nedostupna'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Obriši',
            onPressed: room.id == null ? null : () => _confirmDelete(context, room),
          ),
          onTap: () => _openEditor(context, room: room),
        ),
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, {RoomResponse? room}) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _RoomEditorDialog(room: room),
    );
    if (saved == true) _reload();
  }

  Future<void> _confirmDelete(BuildContext context, RoomResponse room) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Obrisati prostoriju?'),
        content: Text('Remove "${room.name ?? 'this room'}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Odustani')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Obriši')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(roomApiProvider).roomIdDelete(room.id!);
      _reload();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(extractApiErrorMessage(e, fallback: 'Prostoriju nije moguće obrisati.'))),
      );
    }
  }
}

class _RoomEditorDialog extends ConsumerStatefulWidget {
  const _RoomEditorDialog({this.room});
  final RoomResponse? room;

  @override
  ConsumerState<_RoomEditorDialog> createState() => _RoomEditorDialogState();
}

class _RoomEditorDialogState extends ConsumerState<_RoomEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late bool _available;
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.room?.id != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.room?.name ?? '');
    _available = widget.room?.isAvailable ?? true;
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
      final req = RoomUpsertRequest(name: _name.text.trim(), isAvailable: _available);
      final api = ref.read(roomApiProvider);
      if (_isEditing) {
        await api.roomIdPut(widget.room!.id!, roomUpsertRequest: req);
      } else {
        await api.roomPost(roomUpsertRequest: req);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = extractApiErrorMessage(e, fallback: 'Prostoriju nije moguće spasiti.'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Uredi prostoriju' : 'Dodaj prostoriju'),
      content: SizedBox(
        width: 380,
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
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Dostupna'),
                value: _available,
                onChanged: _saving ? null : (v) => setState(() => _available = v),
              ),
              if (_error != null)
                Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
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
