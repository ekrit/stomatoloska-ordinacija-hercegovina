import '../models/doctor.dart';
import '../services/doctor_api_service.dart';

class FakeDoctorApiService implements DoctorApiService {
  @override
  Future<List<Doctor>> fetchDoctors() async {
    await Future.delayed(const Duration(milliseconds: 450));
    return const [
      Doctor(
        id: '1',
        name: 'Dr. Maja Petrovic',
        specialization: 'Orthodontics',
        avatarUrl: 'https://i.pravatar.cc/150?img=47',
      ),
      Doctor(
        id: '2',
        name: 'Dr. Ivan Kovac',
        specialization: 'Implants',
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
      ),
      Doctor(
        id: '3',
        name: 'Dr. Ana Horvat',
        specialization: 'Pediatric Dentistry',
        avatarUrl: 'https://i.pravatar.cc/150?img=32',
      ),
      Doctor(
        id: '4',
        name: 'Dr. Marko Nikolic',
        specialization: 'Oral Surgery',
        avatarUrl: 'https://i.pravatar.cc/150?img=58',
      ),
    ];
  }
}
