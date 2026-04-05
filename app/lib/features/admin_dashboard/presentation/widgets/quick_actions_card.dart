import 'package:flutter/material.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  static const double _rowHeight = 52;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem('Add Patient', Icons.person_add_alt_1_outlined),
      _ActionItem('Manage Doctors', Icons.medical_services_outlined),
      _ActionItem('Edit Office Info', Icons.edit_outlined),
      _ActionItem('Manage Appointments', Icons.calendar_today_outlined),
      _ActionItem('Generate Reports', Icons.bar_chart_outlined),
      _ActionItem('System Settings', Icons.settings_outlined),
    ];

    final buttonStyle = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      alignment: Alignment.center,
      minimumSize: Size.zero,
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: actions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                mainAxisExtent: 52,
              ),
              itemBuilder: (context, index) {
                final action = actions[index];
                return SizedBox.expand(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: buttonStyle,
                    icon: Icon(action.icon, size: 18),
                    label: Text(
                      action.label,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionItem {
  const _ActionItem(this.label, this.icon);

  final String label;
  final IconData icon;
}