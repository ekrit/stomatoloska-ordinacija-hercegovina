import 'package:flutter/material.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _SidebarItem('Dashboard', Icons.grid_view_rounded, true),
      _SidebarItem('Appointments', Icons.calendar_today_outlined, false),
      _SidebarItem('Patients', Icons.people_outline, false),
      _SidebarItem('Staff', Icons.medical_services_outlined, false),
      _SidebarItem('Reports', Icons.bar_chart_outlined, false),
      _SidebarItem('Settings', Icons.settings_outlined, false),
    ];

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        children: [
          Text(
            'Herzegovina Dental Admin',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 20),
          for (final item in items) _SidebarTile(item: item),
        ],
      ),
    );
  }
}

class _SidebarItem {
  const _SidebarItem(this.label, this.icon, this.isActive);

  final String label;
  final IconData icon;
  final bool isActive;
}

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({required this.item});

  final _SidebarItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final textColor = item.isActive
        ? activeColor
        : theme.colorScheme.onSurface.withOpacity(0.7);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: item.isActive ? activeColor.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          leading: Icon(item.icon, size: 20, color: textColor),
          title: Text(
            item.label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: item.isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          onTap: () {},
          dense: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
