import 'package:flutter/material.dart';
import 'package:soh_api/api.dart';

Future<bool> showLogoutConfirm(BuildContext context) async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Log out'),
          ),
        ],
      );
    },
  );

  return shouldLogout ?? false;
}

List<Widget> buildUserAppBarActions({
  required BuildContext context,
  UserResponse? user,
  required bool canLogout,
  Future<void> Function()? onLogout,
  bool showProfile = true,
}) {
  if (!showProfile) {
    return const [];
  }

  final fullName = [
    user?.firstName?.trim(),
    user?.lastName?.trim(),
  ].where((part) => part != null && part!.isNotEmpty).map((e) => e!).join(' ');

  final displayName = fullName.isNotEmpty
      ? fullName
      : (user?.username?.trim().isNotEmpty ?? false)
          ? user!.username!.trim()
          : 'Guest';

  final foreground = Theme.of(context).appBarTheme.foregroundColor ??
      Theme.of(context).colorScheme.onPrimary;

  return [
    Padding(
      padding: const EdgeInsets.only(right: 8),
      child: DefaultTextStyle(
        style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: foreground) ??
            TextStyle(color: foreground),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              child: Icon(
                Icons.person,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 160,
              child: Text(
                displayName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: canLogout && onLogout != null ? () => onLogout() : null,
              tooltip: canLogout ? 'Logout' : 'Settings',
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
      ),
    ),
  ];
}
