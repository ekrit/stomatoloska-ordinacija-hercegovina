import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/storage/auth_storage.dart';
import '../../../../core/utils/role_utils.dart';

/// Splash for the staff desktop app. Restores admin / doctor sessions only;
/// patient sessions are wiped and the user is sent to the login screen
/// (which itself refuses patient logins).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _boot());
  }

  Future<void> _boot() async {
    try {
      final token = await AuthStorage.readToken();
      final user = await AuthStorage.readUser();

      if (!mounted) return;

      if (token != null && token.isNotEmpty && user != null) {
        if (!userIsAdmin(user) && !userIsDoctor(user)) {
          await _clearSessionAndGoLogin();
          return;
        }

        ref.read(authTokenProvider.notifier).state = token;
        ref.read(currentUserProvider.notifier).state = user;

        if (userIsAdmin(user)) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.admin);
          return;
        }
        Navigator.of(context).pushReplacementNamed(AppRoutes.doctor);
        return;
      }

      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }

  Future<void> _clearSessionAndGoLogin() async {
    await AuthStorage.clear();
    ref.read(authTokenProvider.notifier).state = null;
    ref.read(currentUserProvider.notifier).state = null;
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
