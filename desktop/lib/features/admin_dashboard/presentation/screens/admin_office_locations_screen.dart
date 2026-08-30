import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/api_errors.dart';
import '../../../../core/widgets/paginated_search_view.dart';
import 'admin_city_edit_screen.dart';

/// Office / clinic locations directory (cities served).
class AdminOfficeLocationsScreen extends ConsumerStatefulWidget {
  const AdminOfficeLocationsScreen({super.key});

  @override
  ConsumerState<AdminOfficeLocationsScreen> createState() =>
      _AdminOfficeLocationsScreenState();
}

class _AdminOfficeLocationsScreenState extends ConsumerState<AdminOfficeLocationsScreen> {
  int _refresh = 0;

  void _reload() => setState(() => _refresh++);

  /// Delete completes the CRUD the screen was missing: the API supported it,
  /// but there was no way to reach it from the desktop app.
  Future<void> _confirmDelete(CityResponse city) async {
    final id = city.id;
    if (id == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Obrisati lokaciju?'),
        content: Text(
          'Lokacija "${city.name ?? ''}" će biti trajno obrisana. '
          'Ako je koriste korisnici ili termini, server će odbiti brisanje.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Odustani')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Obriši')),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await ref.read(cityApiProvider).cityIdDelete(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lokacija je obrisana.')),
      );
      _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(extractApiErrorMessage(e,
            fallback: 'Lokaciju nije moguće obrisati.'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokacije ordinacije'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final changed = await Navigator.of(context).push<bool>(
            MaterialPageRoute<bool>(builder: (_) => const AdminCityEditScreen()),
          );
          if (changed == true) _reload();
        },
        icon: const Icon(Icons.add),
        label: const Text('Dodaj lokaciju'),
      ),
      body: PaginatedSearchView<CityResponse>(
        refreshKey: _refresh,
        searchHint: 'Pretraži gradove…',
        emptyLabel: 'Nema konfigurisanih gradova.',
        fetch: (query, page, pageSize) async {
          final r = await ref.read(cityApiProvider).cityGet(
                FTS: query.isEmpty ? null : query,
                page: page,
                pageSize: pageSize,
                includeTotalCount: true,
              );
          return PagedData(items: r?.items ?? [], total: r?.totalCount);
        },
        itemBuilder: (context, c) => ListTile(
          leading: const Icon(Icons.location_city),
          title: Text(c.name ?? 'Grad'),
          subtitle: Text(
            [
              c.address,
              c.contactPhone,
              c.workingHours,
            ].where((v) => (v ?? '').trim().isNotEmpty).join(' · '),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Uredi',
                onPressed: () async {
                  final changed = await Navigator.of(context).push<bool>(
                    MaterialPageRoute<bool>(
                      builder: (_) => AdminCityEditScreen(city: c),
                    ),
                  );
                  if (changed == true) _reload();
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Obriši',
                onPressed: () => _confirmDelete(c),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
