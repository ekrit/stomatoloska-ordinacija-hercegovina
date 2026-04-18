import 'package:soh_api/api.dart';

import '../../domain/repositories/patient_care_repository.dart';
import '../services/patient_care_api_service.dart';

class PatientCareRepositoryImpl implements PatientCareRepository {
  PatientCareRepositoryImpl(this._api);

  final PatientCareApiService _api;

  @override
  Future<List<AppointmentResponse>> listAppointmentsForPatient(int patientId) =>
      _api.listAppointmentsForPatient(patientId);

  @override
  Future<List<AppointmentResponse>> listAppointmentsForDoctorBetween({
    required int doctorId,
    required DateTime startInclusive,
    required DateTime endExclusive,
  }) =>
      _api.listAppointmentsForDoctorBetween(
        doctorId: doctorId,
        startInclusive: startInclusive,
        endExclusive: endExclusive,
      );

  @override
  Future<AppointmentResponse?> createAppointment(AppointmentUpsertRequest request) =>
      _api.createAppointment(request);

  @override
  Future<AppointmentResponse?> updateAppointment(
    int id,
    AppointmentUpsertRequest request,
  ) =>
      _api.updateAppointment(id, request);

  @override
  Future<List<MedicalRecordResponse>> listMedicalRecords() =>
      _api.listMedicalRecords();

  @override
  Future<List<MedicalRecordResponse>> listMedicalRecordsForAppointment(
    int appointmentId,
  ) =>
      _api.listMedicalRecordsForAppointment(appointmentId);

  @override
  Future<List<ReviewResponse>> listReviewsForAppointment(int appointmentId) =>
      _api.listReviewsForAppointment(appointmentId);

  @override
  Future<ReviewResponse?> createReview(ReviewUpsertRequest request) =>
      _api.createReview(request);

  @override
  Future<MedicalRecordResponse?> createMedicalRecord(
    MedicalRecordUpsertRequest request,
  ) =>
      _api.createMedicalRecord(request);
}
