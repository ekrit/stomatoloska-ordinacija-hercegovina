import '../models/doctor.dart';

abstract class DoctorApiService {
  Future<List<Doctor>> fetchDoctors();
}
