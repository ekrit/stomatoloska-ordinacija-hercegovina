import '../models/doctor.dart';
import '../services/doctor_api_service.dart';
import '../../domain/repositories/doctor_repository.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  DoctorRepositoryImpl({required DoctorApiService doctorApi})
      : _doctorApi = doctorApi;

  final DoctorApiService _doctorApi;

  @override
  Future<List<Doctor>> fetchDoctors() {
    return _doctorApi.fetchDoctors();
  }
}
