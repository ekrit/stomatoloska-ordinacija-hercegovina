import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/router/app_routes.dart';

final _citiesGuestProvider = FutureProvider.autoDispose<List<CityResponse>>((ref) async {
  final api = ref.watch(cityApiProvider);
  final r = await api.cityGet(retrieveAll: true);
  return r?.items ?? [];
});

class GuestLocationsScreen extends ConsumerWidget {
  const GuestLocationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_citiesGuestProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinic locations'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (cities) {
          if (cities.isEmpty) {
            return const Center(
              child: Text(
                'No cities are published yet. Sign in for full access to booking and services.',
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cities.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final c = cities[i];
              return ListTile(
                leading: const Icon(Icons.location_city_outlined),
                title: Text(c.name ?? 'City'),
                subtitle: const Text(
                  'Stomatološka Ordinacija Hercegovina — public directory entry.',
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.login,
              (route) => false,
            ),
            child: const Text('Back to sign in'),
          ),
        ),
      ),
    );
  }
}
