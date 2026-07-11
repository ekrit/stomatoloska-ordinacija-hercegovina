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

final myAppointmentsProvider =
    FutureProvider.autoDispose<List<AppointmentResponse>>((ref) async {
  final id = ref.watch(currentUserProvider)?.id;
  if (id == null) return [];
  return ref.watch(patientCareRepositoryProvider).listAppointmentsForPatient(id);
});

/// Id used as [OrderUpsertRequest.patientId] and for order history. In this
/// API the [Patient] PK is [Patient.userId].
final patientIdProvider = FutureProvider.autoDispose<int?>((ref) async {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return null;
  final patients =
      await ref.watch(patientSessionRepositoryProvider).listPatientsByUserId(userId);
  if (patients.isEmpty) return null;
  return patients.first.userId ?? userId;
});
