import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_routes.dart';
import 'features/admin_dashboard/presentation/screens/admin_dashboard_screen.dart';
import 'features/auth/presentation/screens/complete_profile_screen.dart';
import 'features/auth/presentation/screens/guest_locations_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/booking/presentation/booking_screen.dart';
import 'features/doctor/presentation/screens/doctor_response_screen.dart';
import 'features/patient/presentation/patient_shell_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: SohApp()));
}

class SohApp extends StatelessWidget {
  const SohApp({super.key});

  static final Map<String, WidgetBuilder> _routes = {
    AppRoutes.splash: (_) => const SplashScreen(),
    AppRoutes.login: (_) => const LoginScreen(),
    AppRoutes.register: (_) => const RegisterScreen(),
    AppRoutes.guest: (_) => const GuestLocationsScreen(),
    AppRoutes.completeProfile: (_) => const CompleteProfileScreen(),
    AppRoutes.patientShell: (_) => const PatientShellScreen(),
    AppRoutes.doctor: (_) => const DoctorResponseScreen(),
    AppRoutes.admin: (_) => const AdminDashboardScreen(),
    AppRoutes.booking: (_) => const BookingScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dental Clinic Herzegovina',
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
