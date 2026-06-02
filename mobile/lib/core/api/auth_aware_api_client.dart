import 'package:http/http.dart';
import 'package:soh_api/api.dart';

/// [ApiClient] that funnels every response through a single place so a 401 can
/// be handled globally (clear session + bounce to login) instead of each
/// screen checking for it. The handler is debounced so a burst of parallel
/// requests failing at once only triggers one logout.
class AuthAwareApiClient extends ApiClient {
  AuthAwareApiClient({
    required super.basePath,
    super.authentication,
    required this.onUnauthorized,
  });

  final void Function() onUnauthorized;
  bool _handling = false;

  @override
  Future<Response> invokeAPI(
    String path,
    String method,
    List<QueryParam> queryParams,
    Object? body,
    Map<String, String> headerParams,
    Map<String, String> formParams,
    String? contentType,
  ) async {
    final response = await super.invokeAPI(
      path,
      method,
      queryParams,
      body,
      headerParams,
      formParams,
      contentType,
    );

    if (response.statusCode == 401 && !_handling) {
      _handling = true;
      onUnauthorized();
    }
    return response;
  }
}
