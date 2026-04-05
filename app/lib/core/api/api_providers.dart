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
