import 'package:soh_api/api.dart';

/// Appointments, medical records, and reviews for the patient app.
abstract class PatientCareRepository {
  Future<List<AppointmentResponse>> listAppointmentsForPatient(int patientId);

  Future<List<AppointmentResponse>> listAppointmentsForDoctorBetween({
    required int doctorId,
    required DateTime startInclusive,
    required DateTime endExclusive,
  });

  Future<AppointmentResponse?> createAppointment(AppointmentUpsertRequest request);

  Future<AppointmentResponse?> updateAppointment(
    int id,
    AppointmentUpsertRequest request,
  );

  Future<List<MedicalRecordResponse>> listMedicalRecords();

  Future<List<MedicalRecordResponse>> listMedicalRecordsForAppointment(
    int appointmentId,
  );

  Future<List<ReviewResponse>> listReviewsForAppointment(int appointmentId);

  Future<ReviewResponse?> createReview(ReviewUpsertRequest request);

  Future<MedicalRecordResponse?> createMedicalRecord(
    MedicalRecordUpsertRequest request,
  );
}
