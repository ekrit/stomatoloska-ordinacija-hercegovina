import 'package:flutter/material.dart';

class AdminSystemSettingsScreen extends StatelessWidget {
  const AdminSystemSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('System settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SettingTile(
            icon: Icons.info_outline,
            title: 'Application profile',
            subtitle: 'Stomatoloska Ordinacija Hercegovina - Admin panel',
          ),
          _SettingTile(
            icon: Icons.security_outlined,
            title: 'Security policy',
            subtitle: 'Manage password and session policy in backend configuration.',
          ),
          _SettingTile(
            icon: Icons.notifications_outlined,
            title: 'Notification channels',
            subtitle: 'Email reminder delivery is configured through API/subscriber environment.',
          ),
          _SettingTile(
            icon: Icons.support_agent_outlined,
            title: 'Support',
            subtitle: 'Contact your system administrator for environment-specific settings.',
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
