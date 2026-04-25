import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../config/app_config.dart';

final authTokenProvider = StateProvider<String?>((ref) => null);

/// Set after login; cleared on logout. Used for app-bar profile and “edit my profile”.
final currentUserProvider = StateProvider<UserResponse?>((ref) => null);

final apiClientProvider = Provider<ApiClient>((ref) {
  final token = ref.watch(authTokenProvider);
  final auth = HttpBearerAuth();
  if (token != null && token.isNotEmpty) {
    auth.accessToken = token;
  }
  return ApiClient(basePath: AppConfig.apiBaseUrl, authentication: auth);
});

final usersApiProvider = Provider<UsersApi>(
  (ref) => UsersApi(ref.watch(apiClientProvider)),
);

final genderApiProvider = Provider<GenderApi>(
  (ref) => GenderApi(ref.watch(apiClientProvider)),
);

final cityApiProvider = Provider<CityApi>(
  (ref) => CityApi(ref.watch(apiClientProvider)),
);

final roleApiProvider = Provider<RoleApi>(
  (ref) => RoleApi(ref.watch(apiClientProvider)),
);

final doctorApiProvider = Provider<DoctorApi>(
  (ref) => DoctorApi(ref.watch(apiClientProvider)),
);

final serviceApiProvider = Provider<ServiceApi>(
  (ref) => ServiceApi(ref.watch(apiClientProvider)),
);

final roomApiProvider = Provider<RoomApi>(
  (ref) => RoomApi(ref.watch(apiClientProvider)),
);

final productApiProvider = Provider<ProductApi>(
  (ref) => ProductApi(ref.watch(apiClientProvider)),
);

final patientApiProvider = Provider<PatientApi>(
  (ref) => PatientApi(ref.watch(apiClientProvider)),
);

final appointmentApiProvider = Provider<AppointmentApi>(
  (ref) => AppointmentApi(ref.watch(apiClientProvider)),
);

final medicalRecordApiProvider = Provider<MedicalRecordApi>(
  (ref) => MedicalRecordApi(ref.watch(apiClientProvider)),
);

final reviewApiProvider = Provider<ReviewApi>(
  (ref) => ReviewApi(ref.watch(apiClientProvider)),
);

final reminderApiProvider = Provider<ReminderApi>(
  (ref) => ReminderApi(ref.watch(apiClientProvider)),
);

final hygieneTrackerApiProvider = Provider<HygieneTrackerApi>(
  (ref) => HygieneTrackerApi(ref.watch(apiClientProvider)),
);

final reportApiProvider = Provider<ReportApi>(
  (ref) => ReportApi(ref.watch(apiClientProvider)),
);

final orderApiProvider = Provider<OrderApi>(
  (ref) => OrderApi(ref.watch(apiClientProvider)),
);
