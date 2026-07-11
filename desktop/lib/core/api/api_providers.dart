import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../app_globals.dart';
import '../config/app_config.dart';
import '../router/app_routes.dart';
import '../storage/auth_storage.dart';
import 'auth_aware_api_client.dart';

final authTokenProvider = StateProvider<String?>((ref) => null);

/// Set after login; cleared on logout. Used for app-bar profile and “edit my profile”.
final currentUserProvider = StateProvider<UserResponse?>((ref) => null);

/// Avoid `http://host:port//path` when joining base + route paths.
String _normalizeApiBaseUrl(String raw) {
  var s = raw.trim();
  while (s.endsWith('/')) {
    s = s.substring(0, s.length - 1);
  }
  return s;
}

/// Clears the local session and routes back to login. Triggered globally
/// whenever the API answers 401 (expired/revoked token).
void _handleUnauthorized(Ref ref) {
  AuthStorage.clear();
  ref.read(authTokenProvider.notifier).state = null;
  ref.read(currentUserProvider.notifier).state = null;
  final nav = rootNavigatorKey.currentState;
  nav?.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final token = ref.watch(authTokenProvider);
  final auth = HttpBearerAuth();
  if (token != null && token.isNotEmpty) {
    auth.accessToken = token;
  }
  return AuthAwareApiClient(
    basePath: _normalizeApiBaseUrl(AppConfig.apiBaseUrl),
    authentication: auth,
    onUnauthorized: () {
      // Defer to the next microtask so we never mutate providers mid-build.
      WidgetsBinding.instance.addPostFrameCallback((_) => _handleUnauthorized(ref));
    },
  );
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

final productCategoryApiProvider = Provider<ProductCategoryApi>(
  (ref) => ProductCategoryApi(ref.watch(apiClientProvider)),
);

final orderApiProvider = Provider<OrderApi>(
  (ref) => OrderApi(ref.watch(apiClientProvider)),
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

final reportApiProvider = Provider<ReportApi>(
  (ref) => ReportApi(ref.watch(apiClientProvider)),
);

final paymentApiProvider = Provider<PaymentApi>(
  (ref) => PaymentApi(ref.watch(apiClientProvider)),
);
