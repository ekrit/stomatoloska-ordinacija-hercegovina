import 'package:flutter/foundation.dart';

class AppConfig {
  static const _apiPort = 5350;
  static const _apiBaseUrlOverride =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');
  static const _isDocker =
      bool.fromEnvironment('IS_DOCKER', defaultValue: false);

  static String get apiBaseUrl {
    final override = _apiBaseUrlOverride.trim();
    if (override.isNotEmpty) {
      return override;
    }

    if (kIsWeb) {
      final host = Uri.base.host.toLowerCase();
      if (host == 'localhost' || host == '127.0.0.1' || host == 'host.docker.internal') {
        return 'http://$host:$_apiPort';
      }
      return Uri.base.origin;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:$_apiPort';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return _isDocker
            ? 'http://host.docker.internal:$_apiPort'
            : 'http://127.0.0.1:$_apiPort';
    }
  }
}
