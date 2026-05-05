import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../core/api/api_providers.dart';
import '../../../core/api/soh_extra_api.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/storage/auth_storage.dart';
import '../../../widgets/user_appbar_actions.dart' show decodeUserPictureBytes, showLogoutConfirm;
import '../../admin_users/presentation/screens/user_edit_screen.dart';
import '../../home/presentation/home_screen.dart';
import 'notification_poll_provider.dart';
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
    final unreadAsync = ref.watch(notificationUnreadPollProvider);
    final unreadCount = unreadAsync.maybeWhen(data: (v) => v, orElse: () => 0);

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
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Appointments',
          ),
          const NavigationDestination(
            icon: Icon(Icons.health_and_safety_outlined),
            selectedIcon: Icon(Icons.health_and_safety),
            label: 'Care',
          ),
          NavigationDestination(
            icon: unreadCount > 0
                ? Badge(
                    label: Text('$unreadCount'),
                    child: const Icon(Icons.person_outline),
                  )
                : const Icon(Icons.person_outline),
            selectedIcon: unreadCount > 0
                ? Badge(
                    label: Text('$unreadCount'),
                    child: const Icon(Icons.person),
                  )
                : const Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _ProfileTab extends ConsumerWidget {
  const _ProfileTab({required this.user, required this.onLogout});

  final UserResponse? user;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final name = [
      user?.firstName?.trim(),
      user?.lastName?.trim(),
    ].where((p) => p != null && p!.isNotEmpty).map((e) => e!).join(' ');
    final displayName = name.isNotEmpty
        ? name
        : (user?.username?.trim().isNotEmpty ?? false)
            ? user!.username!.trim()
            : 'Your profile';
    final pic = decodeUserPictureBytes(user?.picture);

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            pinned: true,
            title: const Text('Profile'),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Card(
                  elevation: 0,
                  color: scheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: scheme.surfaceContainerHighest,
                          backgroundImage: pic != null ? MemoryImage(pic) : null,
                          child: pic == null
                              ? Icon(Icons.person, size: 40, color: scheme.onSurfaceVariant)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              if (user?.email != null && user!.email!.trim().isNotEmpty)
                                Chip(
                                  avatar: const Icon(Icons.mail_outline, size: 18),
                                  label: Text(
                                    user!.email!,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Account',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  color: scheme.surface,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.edit_outlined, color: scheme.primary),
                        title: const Text('Edit my account'),
                        subtitle: const Text('Name, email, photo, and security'),
                        trailing: const Icon(Icons.chevron_right),
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
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.shopping_bag_outlined, color: scheme.primary),
                        title: const Text('My orders'),
                        subtitle: const Text('Products you have ordered'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(context).push<void>(
                            MaterialPageRoute<void>(
                              builder: (_) => const MyOrdersScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Stay informed',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  color: scheme.surface,
                  child: ListTile(
                    leading: Icon(Icons.notifications_active_outlined, color: scheme.primary),
                    title: const Text('Notifications'),
                    subtitle: Text(
                      'Updates refresh automatically about every 45 seconds.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openNotifications(context, ref),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 0,
                  color: scheme.errorContainer.withOpacity(0.35),
                  child: ListTile(
                    leading: Icon(Icons.logout, color: scheme.error),
                    title: Text('Sign out', style: TextStyle(color: scheme.error)),
                    onTap: onLogout,
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openNotifications(BuildContext context, WidgetRef ref) async {
    final api = SohExtraApi(ref.read(apiClientProvider));
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          maxChildSize: 0.92,
          minChildSize: 0.4,
          builder: (context, scroll) {
            return FutureBuilder<List<UserNotificationItem>>(
              future: api.fetchNotifications(take: 40),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ));
                }
                if (snap.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('Could not load notifications: ${snap.error}'),
                  );
                }
                final items = snap.data ?? [];
                if (items.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('No notifications yet.'),
                  );
                }
                return ListView.builder(
                  controller: scroll,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final n = items[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(n.title, style: TextStyle(fontWeight: n.isRead ? FontWeight.normal : FontWeight.w600)),
                        subtitle: Text(n.body),
                        isThreeLine: true,
                        trailing: n.isRead ? null : const Icon(Icons.circle, size: 10),
                        onTap: () async {
                          if (!n.isRead) {
                            try {
                              await api.markNotificationRead(n.id);
                              ref.invalidate(notificationUnreadPollProvider);
                            } catch (_) {}
                          }
                          if (context.mounted) Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
