import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';

/// Small id→label maps used to render human-readable names instead of raw
/// foreign-key ids, and to populate FK dropdowns in admin forms.

final patientsLookupProvider = FutureProvider.autoDispose<Map<int, String>>((ref) async {
  final r = await ref.watch(patientApiProvider).patientGet(pageSize: 100);
  final map = <int, String>{};
  for (final p in r?.items ?? <PatientResponse>[]) {
    if (p.userId != null) {
      final name = '${p.firstName ?? ''} ${p.lastName ?? ''}'.trim();
      map[p.userId!] = name.isEmpty ? 'Patient #${p.userId}' : name;
    }
  }
  return map;
});

final doctorsLookupProvider = FutureProvider.autoDispose<Map<int, String>>((ref) async {
  final r = await ref.watch(doctorApiProvider).doctorGet(pageSize: 100);
  final map = <int, String>{};
  for (final d in r?.items ?? <DoctorResponse>[]) {
    if (d.userId != null) {
      final name = '${d.firstName ?? ''} ${d.lastName ?? ''}'.trim();
      map[d.userId!] = name.isEmpty ? 'Doctor #${d.userId}' : name;
    }
  }
  return map;
});

final servicesLookupProvider = FutureProvider.autoDispose<Map<int, String>>((ref) async {
  final r = await ref.watch(serviceApiProvider).serviceGet(pageSize: 100);
  final map = <int, String>{};
  for (final s in r?.items ?? <ServiceResponse>[]) {
    if (s.id != null) map[s.id!] = s.name ?? 'Service #${s.id}';
  }
  return map;
});

final roomsLookupProvider = FutureProvider.autoDispose<Map<int, String>>((ref) async {
  final r = await ref.watch(roomApiProvider).roomGet(pageSize: 100);
  final map = <int, String>{};
  for (final room in r?.items ?? <RoomResponse>[]) {
    if (room.id != null) map[room.id!] = room.name ?? 'Room #${room.id}';
  }
  return map;
});
