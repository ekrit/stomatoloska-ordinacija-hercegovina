import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

// Memo cache so pictures (avatar, product thumbnails in lists) aren't
// base64-decoded on every widget rebuild. Keyed by the encoded string,
// capped so a long session cannot grow unbounded.
final Map<String, Uint8List?> _decodedPictureCache = <String, Uint8List?>{};
const int _decodedPictureCacheLimit = 128;

Uint8List? decodeUserPictureBytes(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  if (_decodedPictureCache.containsKey(raw)) {
    return _decodedPictureCache[raw];
  }

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

  if (_decodedPictureCache.length >= _decodedPictureCacheLimit) {
    _decodedPictureCache.remove(_decodedPictureCache.keys.first);
  }
  _decodedPictureCache[raw] = decoded;
  return decoded;
}

Future<bool> showLogoutConfirm(BuildContext context) async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Odjava'),
        content: const Text('Da li se zaista želite odjaviti?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Odustani'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Odjava'),
          ),
        ],
      );
    },
  );

  return shouldLogout ?? false;
}
