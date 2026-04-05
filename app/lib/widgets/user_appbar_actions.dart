import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soh_api/api.dart';

Uint8List? decodeUserPictureBytes(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  var s = raw.trim();
  final comma = s.indexOf(',');
  if (s.startsWith('data:') && comma != -1) {
    s = s.substring(comma + 1);
  }
  try {
    return base64Decode(s);
  } catch (_) {
    return null;
  }
}

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

/// Compact avatar for the app bar (e.g. admin dashboard).
Widget buildUserProfileAvatar({
  required BuildContext context,
  UserResponse? user,
  double radius = 16,
  VoidCallback? onTap,
}) {
  final bytes = decodeUserPictureBytes(user?.picture);
  final avatar = CircleAvatar(
    radius: radius,
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    backgroundImage: bytes != null ? MemoryImage(bytes) : null,
    child: bytes == null
        ? Icon(
            Icons.person,
            size: radius * 1.1,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          )
        : null,
  );

  if (onTap == null) {
    return avatar;
  }

  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: Tooltip(
      message: 'Edit profile',
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: avatar,
        ),
      ),
    ),
  );
}

List<Widget> buildUserAppBarActions({
  required BuildContext context,
  UserResponse? user,
  required bool canLogout,
  Future<void> Function()? onLogout,
  bool showProfile = true,
  VoidCallback? onProfileTap,
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

  final bytes = decodeUserPictureBytes(user?.picture);
  final avatar = CircleAvatar(
    radius: 14,
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    backgroundImage: bytes != null ? MemoryImage(bytes) : null,
    child: bytes == null
        ? Icon(
            Icons.person,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          )
        : null,
  );

  final profileRow = Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      avatar,
      const SizedBox(width: 8),
      SizedBox(
        width: 160,
        child: Text(
          displayName,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );

  final interactiveProfile = onProfileTap != null && user?.id != null
      ? MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Tooltip(
            message: 'Edit profile',
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onProfileTap,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: profileRow,
                ),
              ),
            ),
          ),
        )
      : profileRow;

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
            interactiveProfile,
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
