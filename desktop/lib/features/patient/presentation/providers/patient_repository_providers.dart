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

class PatientSessionRepository {
  PatientSessionRepository(this._users, this._patient);

  final UsersApi _users;
  final PatientApi _patient;

  Future<AuthResponse?> authenticate(UserLoginRequest request) =>
      _users.usersAuthenticatePost(userLoginRequest: request);

  Future<UserResponse?> register(UserRegisterRequest request) =>
      _users.usersRegisterPost(userRegisterRequest: request);

  Future<List<PatientResponse>> listPatientsByUserId(int userId) async {
    final r = await _patient.patientGet(userId: userId, pageSize: 100);
    return r?.items ?? [];
  }
}

final patientSessionRepositoryProvider = Provider<PatientSessionRepository>(
  (ref) => PatientSessionRepository(
    ref.watch(usersApiProvider),
    ref.watch(patientApiProvider),
  ),
);
