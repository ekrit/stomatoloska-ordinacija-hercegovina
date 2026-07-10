import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soh_api/api.dart';

// Base64 decoding is costly and several call sites run inside build(), so
// decoded bytes are memoized. Keyed by string identity + length; capped so a
// long session cannot grow unbounded.
final Map<String, Uint8List?> _decodedPictureCache = <String, Uint8List?>{};
const int _decodedPictureCacheLimit = 128;

Uint8List? decodeUserPictureBytes(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  final cached = _decodedPictureCache[raw];
  if (cached != null || _decodedPictureCache.containsKey(raw)) {
    return cached;
  }

  var s = raw.trim();
  final comma = s.indexOf(',');
  if (s.startsWith('data:') && comma != -1) {
    s = s.substring(comma + 1);
  }
  Uint8List? bytes;
  try {
    bytes = base64Decode(s);
  } catch (_) {
    bytes = null;
  }

  if (_decodedPictureCache.length >= _decodedPictureCacheLimit) {
    _decodedPictureCache.remove(_decodedPictureCache.keys.first);
  }
  _decodedPictureCache[raw] = bytes;
  return bytes;
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

