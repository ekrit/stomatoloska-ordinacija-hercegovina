import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/api/soh_extra_api.dart';
import '../../../../core/utils/api_errors.dart';
import '../../../../widgets/user_appbar_actions.dart' show decodeUserPictureBytes;

/// Patient self-edit profile screen for the mobile app.
///
/// Distinct from the admin `UserEditScreen` used by the desktop app:
/// patients cannot change their roles or `isActive` flag, and cannot edit
/// other users. Role/status fields are intentionally absent so a patient
/// can never escalate their own privileges from the UI.
class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key, required this.userId});

  final int userId;

  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _phone = TextEditingController();
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  bool _changePassword = false;
  String? _error;

  UserResponse? _user;
  List<GenderResponse> _genders = const [];
  List<CityResponse> _cities = const [];

  int? _genderId;
  int? _cityId;
  bool _pictureUpdated = false;
  String? _pictureBase64;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _username.dispose();
    _phone.dispose();
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final usersApi = ref.read(usersApiProvider);
      final genderApi = ref.read(genderApiProvider);
      final cityApi = ref.read(cityApiProvider);

      final results = await Future.wait([
        usersApi.usersIdGet(widget.userId),
        genderApi.genderGet(pageSize: 100),
        cityApi.cityGet(pageSize: 100),
      ]);

      final user = results[0] as UserResponse?;
      final gendersPage = results[1] as GenderResponsePagedResult?;
      final citiesPage = results[2] as CityResponsePagedResult?;

      if (user == null) {
        if (!mounted) return;
        setState(() {
          _error = 'Profile not found.';
          _loading = false;
        });
        return;
      }

      if (!mounted) return;

      _user = user;
      _firstName.text = user.firstName ?? '';
      _lastName.text = user.lastName ?? '';
      _email.text = user.email ?? '';
      _username.text = user.username ?? '';
      _phone.text = user.phoneNumber ?? '';
      _genderId = user.genderId;
      _cityId = user.cityId;
      _genders = gendersPage?.items ?? const [];
      _cities = citiesPage?.items ?? const [];
      _pictureBase64 = user.picture;
      _pictureUpdated = false;

      setState(() => _loading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = extractApiErrorMessage(e,
            fallback: 'Could not load your profile.');
        _loading = false;
      });
    }
  }

  Future<void> _pickPicture() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final bytes = result.files.single.bytes;
    if (bytes == null || bytes.isEmpty) return;
    setState(() {
      _pictureBase64 = base64Encode(bytes);
      _pictureUpdated = true;
    });
  }

  String? _validateEmail(String? raw) {
    final v = (raw ?? '').trim();
    if (v.isEmpty) return 'Email is required.';
    // Loose RFC-5322-style check, enough for UI hint; backend re-validates.
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v);
    return ok ? null : 'Enter a valid email (e.g. name@example.com).';
  }

  String? _validatePhone(String? raw) {
    final v = (raw ?? '').trim();
    if (v.isEmpty) return null; // optional
    final ok = RegExp(r'^[+0-9\s().-]{6,20}$').hasMatch(v);
    return ok ? null : 'Enter a valid phone (digits, spaces, +, -, (), 6-20 chars).';
  }

  String? _validateRequired(String? raw, String field) {
    final v = (raw ?? '').trim();
    return v.isEmpty ? '$field is required.' : null;
  }

  String? _validateCurrentPassword(String? raw) {
    if (!_changePassword) return null;
    if ((raw ?? '').isEmpty) return 'Enter your current password.';
    return null;
  }

  String? _validatePassword(String? raw) {
    if (!_changePassword) return null;
    final v = raw ?? '';
    if (v.length < 8) return 'Password must be at least 8 characters.';
    return null;
  }

  String? _validateConfirm(String? raw) {
    if (!_changePassword) return null;
    if ((raw ?? '') != _newPassword.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final gid = _genderId;
    final cid = _cityId;
    if (gid == null || cid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pick a gender and city to continue.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final req = UserUpsertRequest(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        username: _username.text.trim(),
        phoneNumber: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        genderId: gid,
        cityId: cid,
        // Patients cannot deactivate themselves from the UI.
        isActive: _user?.isActive ?? true,
        // Password changes go through the dedicated change-password endpoint
        // (which verifies the current password), never the profile update.
        password: null,
        // Patients cannot edit roles — leave the list empty so the server
        // keeps existing roles. The backend also blocks role escalation.
        roleIds: const [],
        picture: _pictureUpdated ? _pictureBase64 : null,
      );

      await ref.read(usersApiProvider).usersIdPut(
            widget.userId,
            userUpsertRequest: req,
          );

      if (_changePassword && _newPassword.text.isNotEmpty) {
        await SohExtraApi(ref.read(apiClientProvider)).changePassword(
          widget.userId,
          _currentPassword.text,
          _newPassword.text,
        );
      }

      final fresh =
          await ref.read(usersApiProvider).usersIdGet(widget.userId);
      ref.read(currentUserProvider.notifier).state = fresh;

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated.')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(extractApiErrorMessage(e, fallback: 'Could not update profile.'))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget? _picturePreview() {
    // Decoding is memoized in decodeUserPictureBytes, so calling this from
    // build() does not re-decode the image on every frame.
    final bytes = decodeUserPictureBytes(_pictureBase64);
    if (bytes == null) return null;
    return ClipRRect(
      borderRadius: BorderRadius.circular(60),
      child: Image.memory(
        bytes,
        width: 96,
        height: 96,
        fit: BoxFit.cover,
      ),
    );
  }

  int? _dropdownValue(List<dynamic> items, int? selected) {
    final ids = items.map((e) => e.id).whereType<int>().toSet();
    if (selected != null && ids.contains(selected)) return selected;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final preview = _picturePreview();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit my profile'),
        actions: [
          if (!_loading && _error == null && _user != null)
            TextButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _load,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor:
                                  Theme.of(context).colorScheme.surfaceContainerHighest,
                              child: preview ??
                                  const Icon(Icons.person, size: 48),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: _pickPicture,
                              icon: const Icon(Icons.photo_library_outlined),
                              label: const Text('Change photo'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _firstName,
                        decoration: const InputDecoration(
                          labelText: 'First name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => _validateRequired(v, 'First name'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _lastName,
                        decoration: const InputDecoration(
                          labelText: 'Last name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => _validateRequired(v, 'Last name'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _email,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _username,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => _validateRequired(v, 'Username'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone (optional)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: _validatePhone,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        value: _dropdownValue(_genders, _genderId),
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(),
                        ),
                        items: _genders
                            .where((g) => g.id != null)
                            .map(
                              (g) => DropdownMenuItem(
                                value: g.id,
                                child: Text(g.name ?? ''),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _genderId = v),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        value: _dropdownValue(_cities, _cityId),
                        decoration: const InputDecoration(
                          labelText: 'City',
                          border: OutlineInputBorder(),
                        ),
                        items: _cities
                            .where((c) => c.id != null)
                            .map(
                              (c) => DropdownMenuItem(
                                value: c.id,
                                child: Text(c.name ?? ''),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _cityId = v),
                      ),
                      const SizedBox(height: 20),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _changePassword,
                        title: const Text('Change my password'),
                        subtitle: const Text(
                          'Leave this off to keep your current password.',
                        ),
                        onChanged: (v) => setState(() {
                          _changePassword = v;
                          if (!v) {
                            _currentPassword.clear();
                            _newPassword.clear();
                            _confirmPassword.clear();
                          }
                        }),
                      ),
                      if (_changePassword) ...[
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _currentPassword,
                          decoration: const InputDecoration(
                            labelText: 'Current password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: _validateCurrentPassword,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _newPassword,
                          decoration: const InputDecoration(
                            labelText: 'New password',
                            border: OutlineInputBorder(),
                            helperText: 'At least 8 characters.',
                          ),
                          obscureText: true,
                          validator: _validatePassword,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _confirmPassword,
                          decoration: const InputDecoration(
                            labelText: 'Confirm new password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: _validateConfirm,
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}
