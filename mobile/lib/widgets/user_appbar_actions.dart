import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

// Single-entry cache so the avatar isn't base64-decoded on every widget
// rebuild. The raw (encoded) string is the cache key.
String? _cachedPictureKey;
Uint8List? _cachedPictureBytes;

Uint8List? decodeUserPictureBytes(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  if (raw == _cachedPictureKey) return _cachedPictureBytes;

  var s = raw.trim();
  final comma = s.indexOf(',');
  if (s.startsWith('data:') && comma != -1) {
    s = s.substring(comma + 1);
  }
  Uint8List? decoded;
  try {
    decoded = base64Decode(s);
  } catch (_) {
    decoded = null;
  }
  _cachedPictureKey = raw;
  _cachedPictureBytes = decoded;
  return decoded;
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
