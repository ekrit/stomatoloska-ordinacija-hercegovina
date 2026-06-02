import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Office locations'),
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
        label: const Text('Add city'),
      ),
      body: PaginatedSearchView<CityResponse>(
        refreshKey: _refresh,
        searchHint: 'Search cities…',
        emptyLabel: 'No cities configured.',
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
          title: Text(c.name ?? 'City'),
          trailing: const Icon(Icons.edit_outlined),
          onTap: () async {
            final changed = await Navigator.of(context).push<bool>(
              MaterialPageRoute<bool>(
                builder: (_) => AdminCityEditScreen(city: c),
              ),
            );
            if (changed == true) _reload();
          },
        ),
      ),
    );
  }
}
