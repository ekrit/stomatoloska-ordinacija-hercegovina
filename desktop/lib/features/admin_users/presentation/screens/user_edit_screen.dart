import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/api/soh_extra_api.dart';
import '../../../../core/utils/api_errors.dart';
import '../../../../widgets/user_appbar_actions.dart'
    show decodeUserPictureBytes;

class UserEditScreen extends ConsumerStatefulWidget {
  const UserEditScreen({super.key, required this.userId});

  final int userId;

  @override
  ConsumerState<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends ConsumerState<UserEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _phone = TextEditingController();
  final _currentPassword = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  String? _error;

  UserResponse? _user;
  List<GenderResponse> _genders = [];
  List<CityResponse> _cities = [];
  List<RoleResponse> _roles = [];

  int? _genderId;
  int? _cityId;
  final Set<int> _roleIds = {};
  bool _isActive = true;
  bool _pictureUpdated = false;
  String? _pictureBase64;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _username.dispose();
    _phone.dispose();
    _currentPassword.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _load();
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
      final roleApi = ref.read(roleApiProvider);

      final results = await Future.wait([
        usersApi.usersIdGet(widget.userId),
        genderApi.genderGet(pageSize: 100),
        cityApi.cityGet(pageSize: 100),
        roleApi.roleGet(pageSize: 100, isActive: true),
      ]);

      final user = results[0] as UserResponse?;
      final gendersPage = results[1] as GenderResponsePagedResult?;
      final citiesPage = results[2] as CityResponsePagedResult?;
      final rolesPage = results[3] as RoleResponsePagedResult?;

      if (user == null) {
        if (!mounted) return;
        setState(() {
          _error = 'User not found.';
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
      _isActive = user.isActive ?? true;
      _roleIds
        ..clear()
        ..addAll((user.roles ?? []).map((r) => r.id).whereType<int>());
      _genders = gendersPage?.items ?? [];
      _cities = citiesPage?.items ?? [];
      _roles = rolesPage?.items ?? [];
      _pictureBase64 = user.picture;
      _pictureUpdated = false;

      setState(() {
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = extractApiErrorMessage(
          e,
          fallback: 'Could not load the user.',
        );
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
    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) return;
    setState(() {
      _pictureBase64 = base64Encode(bytes);
      _pictureUpdated = true;
    });
  }

  static String _displayName(UserResponse u) {
    final name = [u.firstName, u.lastName]
        .whereType<String>()
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .join(' ');
    return name.isNotEmpty ? name : (u.username ?? '');
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '—';
    final local = d.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  String? _validateRequired(String? raw, String field) {
    final v = (raw ?? '').trim();
    return v.isEmpty ? '$field is required.' : null;
  }

  String? _validateEmail(String? raw) {
    final v = (raw ?? '').trim();
    if (v.isEmpty) return 'Email is required.';
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v);
    return ok ? null : 'Enter a valid email (e.g. name@example.com).';
  }

  String? _validatePhone(String? raw) {
    final v = (raw ?? '').trim();
    if (v.isEmpty) return null; // optional
    final ok = RegExp(r'^[+0-9\s().-]{6,20}$').hasMatch(v);
    return ok
        ? null
        : 'Enter a valid phone (digits, spaces, +, -, (), 6-20 chars).';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final pwd = _password.text;
    final confirm = _confirmPassword.text;
    final isSelf = ref.read(currentUserProvider)?.id == widget.userId;
    if (pwd.isNotEmpty || confirm.isNotEmpty) {
      if (pwd != confirm) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match.')),
        );
        return;
      }
      if (pwd.length < 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password must be at least 4 characters.'),
          ),
        );
        return;
      }
      // Changing your own password requires confirming the current one.
      if (isSelf && _currentPassword.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enter your current password to change it.'),
          ),
        );
        return;
      }
    }

    final gid = _genderId;
    final cid = _cityId;
    if (gid == null || cid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select gender and city.')));
      return;
    }

    setState(() => _saving = true);
    try {
      // Self password change goes through the dedicated endpoint (verifies the
      // current password); admins editing another user set it via the upsert.
      final setPasswordViaUpsert = pwd.isNotEmpty && !isSelf;
      final req = UserUpsertRequest(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        username: _username.text.trim(),
        phoneNumber: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        genderId: gid,
        cityId: cid,
        isActive: _isActive,
        password: setPasswordViaUpsert ? pwd : null,
        roleIds: _roleIds.toList(),
        picture: _pictureUpdated ? _pictureBase64 : null,
      );

      await ref
          .read(usersApiProvider)
          .usersIdPut(widget.userId, userUpsertRequest: req);

      if (isSelf && pwd.isNotEmpty) {
        await SohExtraApi(
          ref.read(apiClientProvider),
        ).changePassword(widget.userId, _currentPassword.text, pwd);
      }

      final me = ref.read(currentUserProvider);
      if (me?.id == widget.userId) {
        final fresh = await ref
            .read(usersApiProvider)
            .usersIdGet(widget.userId);
        ref.read(currentUserProvider.notifier).state = fresh;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User saved.')));
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            extractApiErrorMessage(e, fallback: 'Could not save the user.'),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget? _buildPicturePreview() {
    // decodeUserPictureBytes memoizes, so build() never re-decodes base64.
    final bytes = decodeUserPictureBytes(_pictureBase64);
    if (bytes == null) return null;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.memory(bytes, width: 120, height: 120, fit: BoxFit.cover),
    );
  }

  int? _dropdownGenderValue() {
    final ids = _genders.map((g) => g.id).whereType<int>().toSet();
    if (_genderId != null && ids.contains(_genderId)) return _genderId;
    return null;
  }

  int? _dropdownCityValue() {
    final ids = _cities.map((c) => c.id).whereType<int>().toSet();
    if (_cityId != null && ids.contains(_cityId)) return _cityId;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final u = _user;
    final picturePreview = _buildPicturePreview();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          u != null ? 'Edit user — ${_displayName(u)}' : 'Edit user',
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          if (!_loading && _error == null && u != null)
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
                    FilledButton(onPressed: _load, child: const Text('Retry')),
                  ],
                ),
              ),
            )
          : u == null
          ? const Center(child: Text('User not found.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'System',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                Text('Username: ${u.username ?? '—'}'),
                                Text('Created: ${_formatDate(u.createdAt)}'),
                                Text(
                                  'Last login: ${_formatDate(u.lastLoginAt)}',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Profile',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (picturePreview != null) ...[
                                      picturePreview,
                                      const SizedBox(width: 16),
                                    ],
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: _pickPicture,
                                        icon: const Icon(
                                          Icons.photo_library_outlined,
                                        ),
                                        label: const Text('Pick image'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _firstName,
                                  decoration: const InputDecoration(
                                    labelText: 'First name',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (v) =>
                                      _validateRequired(v, 'First name'),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _lastName,
                                  decoration: const InputDecoration(
                                    labelText: 'Last name',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (v) =>
                                      _validateRequired(v, 'Last name'),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _email,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    helperText: 'Format: name@example.com',
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
                                  validator: (v) =>
                                      _validateRequired(v, 'Username'),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _phone,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone',
                                    helperText: 'E.g. +387 61 123 456',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  validator: _validatePhone,
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<int>(
                                  value: _dropdownGenderValue(),
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
                                  onChanged: (v) =>
                                      setState(() => _genderId = v),
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<int>(
                                  value: _dropdownCityValue(),
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
                                const SizedBox(height: 12),
                                SwitchListTile(
                                  title: const Text('Active'),
                                  value: _isActive,
                                  onChanged: (v) =>
                                      setState(() => _isActive = v),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Roles',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _roles
                                      .where((r) => r.id != null)
                                      .map((r) {
                                        final id = r.id!;
                                        final selected = _roleIds.contains(id);
                                        return FilterChip(
                                          label: Text(r.name ?? ''),
                                          selected: selected,
                                          onSelected: (v) {
                                            setState(() {
                                              if (v) {
                                                _roleIds.add(id);
                                              } else {
                                                _roleIds.remove(id);
                                              }
                                            });
                                          },
                                        );
                                      })
                                      .toList(),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'New password (optional)',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                if (ref.read(currentUserProvider)?.id ==
                                    widget.userId) ...[
                                  TextField(
                                    controller: _currentPassword,
                                    decoration: const InputDecoration(
                                      labelText: 'Current password',
                                      helperText:
                                          'Required only when changing your own password.',
                                      border: OutlineInputBorder(),
                                    ),
                                    obscureText: true,
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                TextField(
                                  controller: _password,
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true,
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _confirmPassword,
                                  decoration: const InputDecoration(
                                    labelText: 'Confirm password',
                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
