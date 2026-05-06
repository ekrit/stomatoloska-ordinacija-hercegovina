import 'package:flutter/material.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    super.key,
    this.selectedId = 'dashboard',
    this.onItemTap,
  });

  final String selectedId;
  final void Function(String id)? onItemTap;

  @override
  Widget build(BuildContext context) {
    final items = [
      const _SidebarItem('dashboard', 'Dashboard', Icons.grid_view_rounded),
      const _SidebarItem('users', 'Users', Icons.group_outlined),
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
          for (final item in items)
            _SidebarTile(
              item: item,
              isActive: item.id == selectedId,
              onTap: () => onItemTap?.call(item.id),
            ),
        ],
      ),
    );
  }
}

class _SidebarItem {
  const _SidebarItem(this.id, this.label, this.icon);

  final String id;
  final String label;
  final IconData icon;
}

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _SidebarItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final textColor = isActive
        ? activeColor
        : theme.colorScheme.onSurface.withOpacity(0.7);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: isActive ? activeColor.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          leading: Icon(item.icon, size: 20, color: textColor),
          title: Text(
            item.label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          onTap: onTap,
          dense: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
