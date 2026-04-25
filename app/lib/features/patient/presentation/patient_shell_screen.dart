import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../core/api/api_providers.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/storage/auth_storage.dart';
import '../../../widgets/user_appbar_actions.dart' show showLogoutConfirm;
import '../../admin_users/presentation/screens/user_edit_screen.dart';
import '../../home/presentation/home_screen.dart';
import 'screens/my_appointments_screen.dart';
import 'screens/my_orders_screen.dart';
import 'screens/reminders_hygiene_screen.dart';

class PatientShellScreen extends ConsumerStatefulWidget {
  const PatientShellScreen({super.key});

  @override
  ConsumerState<PatientShellScreen> createState() => _PatientShellScreenState();
}

class _PatientShellScreenState extends ConsumerState<PatientShellScreen> {
  int _index = 0;

  Future<void> _logout(BuildContext context) async {
    final ok = await showLogoutConfirm(context);
    if (!ok) return;
    await AuthStorage.clear();
    ref.read(authTokenProvider.notifier).state = null;
    ref.read(currentUserProvider.notifier).state = null;
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(
            onBook: () => Navigator.of(context).pushNamed(AppRoutes.booking),
          ),
          const MyAppointmentsScreen(),
          const RemindersHygieneScreen(),
          _ProfileTab(
            user: user,
            onLogout: () => _logout(context),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Appointments',
          ),
          NavigationDestination(
            icon: Icon(Icons.health_and_safety_outlined),
            selectedIcon: Icon(Icons.health_and_safety),
            label: 'Care',
          ),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({required this.user, required this.onLogout});

  final UserResponse? user;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Edit my account'),
            subtitle: const Text('Name, email, photo, and security'),
            onTap: user?.id == null
                ? null
                : () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) => UserEditScreen(userId: user!.id!),
                      ),
                    );
                  },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text('My orders'),
            subtitle: const Text('View your product orders'),
            onTap: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => const MyOrdersScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
