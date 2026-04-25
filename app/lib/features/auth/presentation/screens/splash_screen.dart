import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/storage/auth_storage.dart';
import '../../../../core/utils/role_utils.dart';
import '../../../patient/presentation/providers/patient_repository_providers.dart';

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
    final token = await AuthStorage.readToken();
    final user = await AuthStorage.readUser();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      ref.read(authTokenProvider.notifier).state = token;
      if (user != null) {
        ref.read(currentUserProvider.notifier).state = user;
        if (userIsAdmin(user)) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.admin);
          return;
        }
        if (userIsDoctor(user)) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.doctor);
          return;
        }
        if (user.id != null) {
          final existing = await ref
              .read(patientSessionRepositoryProvider)
              .listPatientsByUserId(user.id!);
          if (existing.isEmpty) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.completeProfile);
            return;
          }
        }
        Navigator.of(context).pushReplacementNamed(AppRoutes.patientShell);
        return;
      }
    }

    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
