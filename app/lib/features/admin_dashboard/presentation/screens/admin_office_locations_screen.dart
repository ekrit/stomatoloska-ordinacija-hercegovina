import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import 'admin_city_edit_screen.dart';

final _citiesAdminProvider = FutureProvider.autoDispose<List<CityResponse>>((ref) async {
  final r = await ref.watch(cityApiProvider).cityGet(retrieveAll: true);
  return r?.items ?? [];
});

/// Office / clinic locations directory (cities served). Editing is done via user & system APIs.
class AdminOfficeLocationsScreen extends ConsumerWidget {
  const AdminOfficeLocationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_citiesAdminProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Office locations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_citiesAdminProvider),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (cities) {
          if (cities.isEmpty) {
            return const Center(child: Text('No cities configured.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Locations where the clinic is registered in the system. '
                'Detailed address and working hours can be extended in future iterations.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ...cities.map(
                (c) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(c.name ?? 'City'),
                    subtitle: Text('City ID: ${c.id ?? '—'}'),
                    trailing: const Icon(Icons.edit_outlined),
                    onTap: () async {
                      final changed = await Navigator.of(context).push<bool>(
                        MaterialPageRoute<bool>(
                          builder: (_) => AdminCityEditScreen(city: c),
                        ),
                      );
                      if (changed == true) {
                        ref.invalidate(_citiesAdminProvider);
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
