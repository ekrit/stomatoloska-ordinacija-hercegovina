import 'package:soh_api/api.dart';

import 'patient_care_api_service.dart';

class PatientCareApiServiceImpl implements PatientCareApiService {
  PatientCareApiServiceImpl(
    this._appointments,
    this._medicalRecords,
    this._reviews,
  );

  final AppointmentApi _appointments;
  final MedicalRecordApi _medicalRecords;
  final ReviewApi _reviews;

  @override
  Future<List<AppointmentResponse>> listAppointmentsForPatient(int patientId) async {
    final r = await _appointments.appointmentGet(
      patientId: patientId,
      retrieveAll: true,
    );
    return r?.items ?? [];
  }

  @override
  Future<List<AppointmentResponse>> listAppointmentsForDoctorBetween({
    required int doctorId,
    required DateTime startInclusive,
    required DateTime endExclusive,
  }) async {
    final r = await _appointments.appointmentGet(
      doctorId: doctorId,
      startFrom: startInclusive,
      startTo: endExclusive,
      retrieveAll: true,
    );
    return r?.items ?? [];
  }

  @override
  Future<AppointmentResponse?> createAppointment(AppointmentUpsertRequest request) {
    return _appointments.appointmentPost(appointmentUpsertRequest: request);
  }

  @override
  Future<AppointmentResponse?> updateAppointment(
    int id,
    AppointmentUpsertRequest request,
  ) {
    return _appointments.appointmentIdPut(id, appointmentUpsertRequest: request);
  }

  @override
  Future<List<MedicalRecordResponse>> listMedicalRecords() async {
    final r = await _medicalRecords.medicalRecordGet(retrieveAll: true);
    return r?.items ?? [];
  }

  @override
  Future<List<MedicalRecordResponse>> listMedicalRecordsForAppointment(
    int appointmentId,
  ) async {
    final r = await _medicalRecords.medicalRecordGet(
      appointmentId: appointmentId,
      retrieveAll: true,
    );
    return r?.items ?? [];
  }

  @override
  Future<List<ReviewResponse>> listReviewsForAppointment(int appointmentId) async {
    final r = await _reviews.reviewGet(
      appointmentId: appointmentId,
      retrieveAll: true,
    );
    return r?.items ?? [];
  }

  @override
  Future<ReviewResponse?> createReview(ReviewUpsertRequest request) {
    return _reviews.reviewPost(reviewUpsertRequest: request);
  }

  @override
  Future<MedicalRecordResponse?> createMedicalRecord(
    MedicalRecordUpsertRequest request,
  ) {
    return _medicalRecords.medicalRecordPost(
      medicalRecordUpsertRequest: request,
    );
  }
}
