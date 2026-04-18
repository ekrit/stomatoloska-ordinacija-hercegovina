import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import 'patient_repository_providers.dart';

final doctorsProvider = FutureProvider.autoDispose<List<DoctorResponse>>((ref) async {
  return ref.watch(patientCatalogRepositoryProvider).listDoctors();
});

final servicesProvider = FutureProvider.autoDispose<List<ServiceResponse>>((ref) async {
  return ref.watch(patientCatalogRepositoryProvider).listServices();
});

final roomsProvider = FutureProvider.autoDispose<List<RoomResponse>>((ref) async {
  return ref.watch(patientCatalogRepositoryProvider).listRooms();
});

final productsProvider = FutureProvider.autoDispose<List<ProductResponse>>((ref) async {
  return ref.watch(patientCatalogRepositoryProvider).listProducts();
});

final myAppointmentsProvider =
    FutureProvider.autoDispose<List<AppointmentResponse>>((ref) async {
  final id = ref.watch(currentUserProvider)?.id;
  if (id == null) return [];
  return ref.watch(patientCareRepositoryProvider).listAppointmentsForPatient(id);
});

final medicalRecordsProvider =
    FutureProvider.autoDispose<List<MedicalRecordResponse>>((ref) async {
  return ref.watch(patientCareRepositoryProvider).listMedicalRecords();
});

/// Simple content-based filtering.
///
/// If [recentServiceName] is available, prefer products whose name/category
/// matches keywords from that service. Otherwise, fall back to oral-care-ish
/// categories; else return first items.
List<ProductResponse> recommendedProducts(
  List<ProductResponse> all, {
  int max = 6,
  String? recentServiceName,
}) {
  if (all.isEmpty) return [];

  final serviceKeywords = _keywords(recentServiceName);
  if (serviceKeywords.isNotEmpty) {
    final matched = all.where((p) {
      final hay = '${p.name ?? ''} ${p.category ?? ''}'.toLowerCase();
      for (final k in serviceKeywords) {
        if (hay.contains(k)) return true;
      }
      return false;
    }).toList();
    if (matched.isNotEmpty) {
      matched.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
      return matched.take(max).toList();
    }
  }

  final oralCare = all.where((p) {
    final c = (p.category ?? '').toLowerCase();
    return c.contains('oral') ||
        c.contains('tooth') ||
        c.contains('brush') ||
        c.contains('dental');
  }).toList();

  final source = oralCare.isNotEmpty ? oralCare : all;
  source.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
  return source.take(max).toList();
}

Set<String> _keywords(String? raw) {
  final s = (raw ?? '').toLowerCase().trim();
  if (s.isEmpty) return const {};
  final parts = s
      .split(RegExp(r'[^a-z0-9šđčćž]+', caseSensitive: false))
      .map((p) => p.trim())
      .where((p) => p.length >= 4)
      .toSet();
  return parts;
}
