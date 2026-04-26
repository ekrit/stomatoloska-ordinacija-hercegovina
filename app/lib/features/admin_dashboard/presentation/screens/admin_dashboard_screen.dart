import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/storage/auth_storage.dart';
import '../../../admin_users/presentation/screens/user_edit_screen.dart';
import '../../../admin_users/presentation/screens/users_list_screen.dart';
import '../../../../widgets/user_appbar_actions.dart';
import '../providers/admin_dashboard_providers.dart';
import '../widgets/dashboard_sidebar.dart';
import '../widgets/monthly_appointments_chart.dart';
import '../widgets/admin_dashboard_search_bar.dart';
import '../widgets/quick_actions_card.dart';
import '../widgets/recent_activity_section.dart';
import '../widgets/revenue_breakdown_chart.dart';
import '../widgets/staff_spotlight_card.dart';
import '../widgets/stat_card.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 1200;
    final isMobile = width < 900;

    void openSidebarSection(String id) {
      if (id == 'users') {
        Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) => const UsersListScreen(),
          ),
        );
      }
    }

    Future<void> logout() async {
      final ok = await showLogoutConfirm(context);
      if (!ok) return;
      await AuthStorage.clear();
      ref.read(currentUserProvider.notifier).state = null;
      if (!context.mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
    }

    final sidebar = DashboardSidebar(
      selectedId: 'dashboard',
      onItemTap: openSidebarSection,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const SizedBox.shrink(),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          AdminDashboardSearchBar(width: isMobile ? 180 : 320),
          const SizedBox(width: 12),
          Builder(
            builder: (context) {
              final me = ref.watch(currentUserProvider);
              final id = me?.id;
              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: buildUserProfileAvatar(
                  context: context,
                  user: me,
                  radius: 16,
                  onTap: id != null
                      ? () {
                          Navigator.of(context).push<void>(
                            MaterialPageRoute<void>(
                              builder: (_) => UserEditScreen(userId: id),
                            ),
                          );
                        }
                      : null,
                ),
              );
            },
          ),
          IconButton(
            onPressed: logout,
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 12),
        ],
      ),
      drawer: isMobile ? Drawer(child: sidebar) : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile) sidebar,
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsSection(context, ref, width),
                  const SizedBox(height: 24),
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              _buildChartsRow(context, ref),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              const QuickActionsCard(),
                              const SizedBox(height: 24),
                              _buildStaffSpotlight(ref),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildChartsStack(context, ref),
                        const SizedBox(height: 24),
                        const QuickActionsCard(),
                        const SizedBox(height: 24),
                        _buildStaffSpotlight(ref),
                      ],
                    ),
                  const SizedBox(height: 24),
                  const RecentActivitySection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, WidgetRef ref, double width) {
    final columns = width >= 1200 ? 4 : width >= 900 ? 3 : 2;
    final statsAsync = ref.watch(dashboardStatsProvider);

    return statsAsync.when(
      loading: () => const SizedBox(
        height: 140,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Text('Failed to load stats: $error'),
      data: (stats) {
        final primary = [
          StatCard(
            title: 'Active users',
            value: stats.activeUsers.toString(),
            subtitle: 'Accounts currently marked active',
            icon: Icons.people_outline,
          ),
          StatCard(
            title: 'Doctors',
            value: stats.totalDoctors.toString(),
            subtitle: 'Registered doctors',
            icon: Icons.medical_services_outlined,
          ),
          StatCard(
            title: 'Rooms',
            value: stats.totalRooms.toString(),
            subtitle: 'Clinic treatment rooms',
            icon: Icons.meeting_room_outlined,
          ),
          StatCard(
            title: 'Average earnings',
            value: '€ ${stats.averageEarnings.toStringAsFixed(0)}',
            subtitle: 'Per doctor, last 30 days',
            icon: Icons.euro_outlined,
            accentColor: Colors.green,
          ),
        ];

        final secondary = [
          StatCard(
            title: 'Total users',
            value: stats.totalUsers.toString(),
            subtitle: 'All user accounts in system',
            icon: Icons.groups_outlined,
          ),
          StatCard(
            title: 'Completed appointments',
            value: stats.completedAppointments.toString(),
            subtitle: 'Last 30 days',
            icon: Icons.check_circle_outline,
          ),
          StatCard(
            title: 'Cancelled appointments',
            value: stats.cancelledAppointments.toString(),
            subtitle: 'Last 30 days',
            icon: Icons.cancel_outlined,
            accentColor: Colors.orange,
          ),
          StatCard(
            title: 'New patients (month)',
            value: stats.newPatientsThisMonth.toString(),
            subtitle: 'In the current month',
            icon: Icons.person_add_alt_1_outlined,
            accentColor: Colors.blueGrey,
          ),
          StatCard(
            title: 'Revenue growth',
            value: '${stats.revenueGrowth >= 0 ? '+' : ''}${stats.revenueGrowth.toStringAsFixed(1)}%',
            subtitle: 'Compared to previous 30 days',
            icon: Icons.trending_up_outlined,
            accentColor: Colors.purple,
          ),
        ];

        Widget grid(List<StatCard> cards) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.95,
            ),
            itemCount: cards.length,
            itemBuilder: (context, index) => cards[index],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            grid(primary),
            const SizedBox(height: 20),
            Text(
              'Additional statistics',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
            ),
            const SizedBox(height: 12),
            grid(secondary),
          ],
        );
      },
    );
  }

  Widget _buildChartsRow(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _ChartCard(
            title: 'Monthly Appointments Trend',
            child: _buildAppointmentsChart(ref),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _ChartCard(
            title: 'Service Revenue Breakdown',
            child: _buildRevenueChart(ref),
          ),
        ),
      ],
    );
  }

  Widget _buildChartsStack(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _ChartCard(
          title: 'Monthly Appointments Trend',
          child: _buildAppointmentsChart(ref),
        ),
        const SizedBox(height: 24),
        _ChartCard(
          title: 'Service Revenue Breakdown',
          child: _buildRevenueChart(ref),
        ),
      ],
    );
  }

  Widget _buildAppointmentsChart(WidgetRef ref) {
    final statsAsync = ref.watch(appointmentStatsProvider);
    return statsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text('Failed to load appointments: $error'),
      data: (stats) => MonthlyAppointmentsChart(stats: stats),
    );
  }

  Widget _buildRevenueChart(WidgetRef ref) {
    final statsAsync = ref.watch(revenueStatsProvider);
    return statsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text('Failed to load revenue: $error'),
      data: (stats) => RevenueBreakdownChart(stats: stats),
    );
  }

  Widget _buildStaffSpotlight(WidgetRef ref) {
    final doctorsAsync = ref.watch(doctorsProvider);
    return doctorsAsync.when(
      loading: () => const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Text('Failed to load staff: $error'),
      data: (doctors) => StaffSpotlightCard(doctors: doctors),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 240,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
