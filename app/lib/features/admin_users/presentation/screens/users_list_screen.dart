import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import 'user_edit_screen.dart';

class UsersListScreen extends ConsumerStatefulWidget {
  const UsersListScreen({super.key});

  @override
  ConsumerState<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends ConsumerState<UsersListScreen> {
  List<UserResponse> _users = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final api = ref.read(usersApiProvider);
      final page = await api.usersGet(retrieveAll: true);
      if (!mounted) return;
      setState(() {
        _users = page?.items ?? [];
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  String _rolesSummary(UserResponse u) {
    final roles = u.roles ?? [];
    if (roles.isEmpty) return '—';
    return roles
        .map((r) => r.name ?? '')
        .where((n) => n.isNotEmpty)
        .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'Users',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _load,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: _users.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final u = _users[index];
                      final name = [
                        u.firstName?.trim(),
                        u.lastName?.trim(),
                      ].whereType<String>().where((p) => p.isNotEmpty).join(' ');
                      return Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          title: Text(
                            name.isNotEmpty ? name : (u.username ?? '—'),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${u.email ?? ''}\n${_rolesSummary(u)}',
                          ),
                          isThreeLine: true,
                          trailing: Icon(
                            u.isActive == true
                                ? Icons.check_circle_outline
                                : Icons.cancel_outlined,
                            color: u.isActive == true ? Colors.green : Colors.grey,
                          ),
                          onTap: () async {
                            final id = u.id;
                            if (id == null) return;
                            await Navigator.of(context).push<void>(
                              MaterialPageRoute(
                                builder: (_) => UserEditScreen(userId: id),
                              ),
                            );
                            _load();
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
