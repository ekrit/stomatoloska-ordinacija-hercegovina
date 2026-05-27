import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/repositories/patient_care_repository_impl.dart';
import '../../data/services/patient_care_api_service_impl.dart';
import '../../domain/repositories/patient_care_repository.dart';

final patientCareRepositoryProvider = Provider<PatientCareRepository>((ref) {
  return PatientCareRepositoryImpl(
    PatientCareApiServiceImpl(
      ref.watch(appointmentApiProvider),
      ref.watch(medicalRecordApiProvider),
      ref.watch(reviewApiProvider),
    ),
  );
});

/// Catalog data for booking and home (doctors, services, rooms, products).
class PatientCatalogRepository {
  PatientCatalogRepository(
    this._doctor,
    this._service,
    this._room,
    this._product,
  );

  final DoctorApi _doctor;
  final ServiceApi _service;
  final RoomApi _room;
  final ProductApi _product;

  Future<List<DoctorResponse>> listDoctors() async {
    final r = await _doctor.doctorGet(retrieveAll: true);
    return r?.items ?? [];
  }

  Future<List<ServiceResponse>> listServices() async {
    final r = await _service.serviceGet(retrieveAll: true);
    return r?.items ?? [];
  }

  Future<List<RoomResponse>> listRooms() async {
    final r = await _room.roomGet(retrieveAll: true);
    return r?.items ?? [];
  }

  Future<List<ProductResponse>> listProducts() async {
    final r = await _product.productGet(retrieveAll: true);
    return r?.items ?? [];
  }
}

final patientCatalogRepositoryProvider = Provider<PatientCatalogRepository>(
  (ref) => PatientCatalogRepository(
    ref.watch(doctorApiProvider),
    ref.watch(serviceApiProvider),
    ref.watch(roomApiProvider),
    ref.watch(productApiProvider),
  ),
);

class PatientSessionRepository {
  PatientSessionRepository(this._users, this._patient);

  final UsersApi _users;
  final PatientApi _patient;

  Future<AuthResponse?> authenticate(UserLoginRequest request) =>
      _users.usersAuthenticatePost(userLoginRequest: request);

  Future<UserResponse?> register(UserRegisterRequest request) =>
      _users.usersRegisterPost(userRegisterRequest: request);

  Future<List<PatientResponse>> listPatientsByUserId(int userId) async {
    final r = await _patient.patientGet(userId: userId, retrieveAll: true);
    return r?.items ?? [];
  }
}

final patientSessionRepositoryProvider = Provider<PatientSessionRepository>(
  (ref) => PatientSessionRepository(
    ref.watch(usersApiProvider),
    ref.watch(patientApiProvider),
  ),
);
