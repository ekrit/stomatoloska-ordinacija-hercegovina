import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:soh_api/api.dart';

abstract final class AuthStorage {
  static const _tokenKey = 'soh_auth_token';
  static const _userKey = 'soh_auth_user_json';

  static Future<void> saveSession({
    required String token,
    UserResponse? user,
  }) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_tokenKey, token);
    if (user == null) {
      await p.remove(_userKey);
      return;
    }
    final map = <String, dynamic>{
      'id': user.id,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'username': user.username,
      'picture': user.picture,
      'isActive': user.isActive,
      'createdAt': user.createdAt?.toUtc().toIso8601String(),
      'lastLoginAt': user.lastLoginAt?.toUtc().toIso8601String(),
      'phoneNumber': user.phoneNumber,
      'genderId': user.genderId,
      'genderName': user.genderName,
      'cityId': user.cityId,
      'cityName': user.cityName,
      'roles': (user.roles ?? [])
          .map((r) => {'id': r.id, 'name': r.name, 'description': r.description})
          .toList(),
    };
    await p.setString(_userKey, jsonEncode(map));
  }

  static Future<String?> readToken() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_tokenKey);
  }

  static Future<UserResponse?> readUser() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_userKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return UserResponse.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_tokenKey);
    await p.remove(_userKey);
  }
}
