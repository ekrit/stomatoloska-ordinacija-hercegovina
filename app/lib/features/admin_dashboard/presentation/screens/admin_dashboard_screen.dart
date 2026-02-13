import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/admin_dashboard_providers.dart';
import '../widgets/dashboard_sidebar.dart';
import '../widgets/monthly_appointments_chart.dart';
import '../widgets/quick_actions_card.dart';
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

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Herzegovina Dental Admin',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          SizedBox(
            width: isMobile ? 180 : 320,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search patients, doctors, appointments...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.black12,
            child: Icon(Icons.person, color: Colors.black87, size: 18),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: isMobile ? const Drawer(child: DashboardSidebar()) : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile) const DashboardSidebar(),
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
        final items = [
          StatCard(
            title: 'Total Doctors',
            value: stats.totalDoctors.toString(),
            subtitle: 'Active practitioners',
            icon: Icons.medical_services_outlined,
          ),
          StatCard(
            title: 'Total Practices',
            value: stats.totalPractices.toString(),
            subtitle: 'Operational clinics',
            icon: Icons.location_city_outlined,
          ),
          StatCard(
            title: 'Total Users',
            value: stats.totalUsers.toString(),
            subtitle: 'Registered patients & staff',
            icon: Icons.people_outline,
          ),
          StatCard(
            title: 'Completed Appointments',
            value: stats.completedAppointments.toString(),
            subtitle: 'Last 30 days',
            icon: Icons.check_circle_outline,
          ),
          StatCard(
            title: 'Cancelled Appointments',
            value: stats.cancelledAppointments.toString(),
            subtitle: 'Last 30 days',
            icon: Icons.cancel_outlined,
            accentColor: Colors.orange,
          ),
          StatCard(
            title: 'Average Earnings',
            value: '€ ${stats.averageEarnings.toStringAsFixed(0)}',
            subtitle: 'Per doctor, last month',
            icon: Icons.euro_outlined,
            accentColor: Colors.green,
          ),
          StatCard(
            title: 'New Patients This Month',
            value: stats.newPatientsThisMonth.toString(),
            subtitle: 'From various sources',
            icon: Icons.person_add_alt_1_outlined,
            accentColor: Colors.blueGrey,
          ),
          StatCard(
            title: 'Revenue Growth',
            value: '+${stats.revenueGrowth.toStringAsFixed(1)}%',
            subtitle: 'Compared to previous',
            icon: Icons.trending_up_outlined,
            accentColor: Colors.purple,
          ),
        ];

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.2,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => items[index],
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
