import '../../data/models/doctor.dart';

abstract class DoctorRepository {
  Future<List<Doctor>> fetchDoctors();
}
