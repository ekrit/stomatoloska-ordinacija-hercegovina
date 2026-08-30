import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/storage/auth_storage.dart';
import '../../../../core/utils/role_utils.dart';
import '../../../patient/presentation/providers/patient_repository_providers.dart';

/// Splash for the mobile app. Restores a patient or doctor session if one
/// exists. Admin sessions are wiped and the user is sent to the login screen
/// (with the mobile login refusing admin accounts).
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

      if (token != null && token.isNotEmpty) {
        if (user != null && userIsAdmin(user)) {
          await _clearSessionAndGoLogin();
          return;
        }

        ref.read(authTokenProvider.notifier).state = token;
        if (user != null) {
          ref.read(currentUserProvider.notifier).state = user;

          if (userIsDoctor(user)) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.doctorShell);
            return;
          }

          // A stored session still has to be checked for validity, but the
          // patient chart no longer needs probing: it is created together with
          // the account. We only care whether the token is still accepted.
          if (user.id != null) {
            try {
              await ref
                  .read(patientSessionRepositoryProvider)
                  .listPatientsByUserId(user.id!);
            } on ApiException catch (e) {
              if (!mounted) return;
              if (e.code == 401 || e.code == 403) {
                await _clearSessionAndGoLogin();
                return;
              }
            } catch (_) {
              // Offline or a transient server error: fall through to the shell
              // rather than bouncing the user back to the login form.
            }
          }
          if (!mounted) return;
          Navigator.of(context).pushReplacementNamed(AppRoutes.patientShell);
          return;
        }
      }

      if (!mounted) return;
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
