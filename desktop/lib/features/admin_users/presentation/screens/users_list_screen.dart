import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/widgets/paginated_search_view.dart';
import '../../../../widgets/user_appbar_actions.dart' show decodeUserPictureBytes;
import 'user_edit_screen.dart';

class UsersListScreen extends ConsumerStatefulWidget {
  const UsersListScreen({super.key});

  @override
  ConsumerState<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends ConsumerState<UsersListScreen> {
  int _refresh = 0;

  void _reload() => setState(() => _refresh++);

  String _rolesSummary(UserResponse u) {
    final roles = u.roles ?? [];
    if (roles.isEmpty) return '—';
    return roles.map((r) => r.name ?? '').where((n) => n.isNotEmpty).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Korisnici', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
        ],
      ),
      body: PaginatedSearchView<UserResponse>(
        refreshKey: _refresh,
        searchHint: 'Pretraži po imenu, korisničkom imenu ili e-mailu…',
        emptyLabel: 'Nema pronađenih korisnika.',
        fetch: (query, page, pageSize) async {
          final r = await ref.read(usersApiProvider).usersGet(
                FTS: query.isEmpty ? null : query,
                page: page,
                pageSize: pageSize,
                includeTotalCount: true,
              );
          return PagedData(items: r?.items ?? [], total: r?.totalCount);
        },
        itemBuilder: (context, u) {
          final name = [u.firstName?.trim(), u.lastName?.trim()]
              .whereType<String>()
              .where((p) => p.isNotEmpty)
              .join(' ');
          final pic = decodeUserPictureBytes(u.picture);
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: pic != null ? MemoryImage(pic) : null,
              child: pic == null ? const Icon(Icons.person_outline) : null,
            ),
            title: Text(
              name.isNotEmpty ? name : (u.username ?? '—'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('${u.email ?? ''}\n${_rolesSummary(u)}'),
            isThreeLine: true,
            trailing: Icon(
              u.isActive == true ? Icons.check_circle_outline : Icons.cancel_outlined,
              color: u.isActive == true ? Colors.green : Colors.grey,
            ),
            onTap: () async {
              final id = u.id;
              if (id == null) return;
              await Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => UserEditScreen(userId: id)),
              );
              _reload();
            },
          );
        },
      ),
    );
  }
}
