import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../config/app_config.dart';

final authTokenProvider = StateProvider<String?>((ref) => null);

final apiClientProvider = Provider<ApiClient>((ref) {
  final token = ref.watch(authTokenProvider);
  final auth = HttpBearerAuth();
  if (token != null && token.isNotEmpty) {
    auth.accessToken = token;
  }
  return ApiClient(basePath: AppConfig.apiBaseUrl, authentication: auth);
});
