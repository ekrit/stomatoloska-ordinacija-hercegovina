import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app_globals.dart';
import 'core/router/app_routes.dart';
import 'features/admin_dashboard/presentation/screens/admin_dashboard_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/doctor/presentation/screens/doctor_response_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: SohDesktopApp()));
}

class SohDesktopApp extends StatelessWidget {
  const SohDesktopApp({super.key});

  static final Map<String, WidgetBuilder> _routes = {
    AppRoutes.splash: (_) => const SplashScreen(),
    AppRoutes.login: (_) => const LoginScreen(),
    AppRoutes.doctor: (_) => const DoctorResponseScreen(),
    AppRoutes.admin: (_) => const AdminDashboardScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dental Clinic Herzegovina - Staff',
      navigatorKey: rootNavigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      routes: _routes,
      onUnknownRoute: (_) {
        return MaterialPageRoute<void>(
          builder: (_) => const SplashScreen(),
          settings: const RouteSettings(name: AppRoutes.splash),
        );
      },
    );
  }
}
