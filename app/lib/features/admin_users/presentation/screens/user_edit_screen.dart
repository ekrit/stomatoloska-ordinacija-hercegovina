import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';

class UserEditScreen extends ConsumerStatefulWidget {
  const UserEditScreen({super.key, required this.userId});

  final int userId;

  @override
  ConsumerState<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends ConsumerState<UserEditScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _phone = TextEditingController();
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
        genderApi.genderGet(retrieveAll: true),
        cityApi.cityGet(retrieveAll: true),
        roleApi.roleGet(retrieveAll: true, isActive: true),
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
        ..addAll(
          (user.roles ?? [])
              .map((r) => r.id)
              .whereType<int>(),
        );
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
        _error = e.toString();
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

  String _formatDate(DateTime? d) {
    if (d == null) return '—';
    final local = d.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _save() async {
    final pwd = _password.text;
    final confirm = _confirmPassword.text;
    if (pwd.isNotEmpty || confirm.isNotEmpty) {
      if (pwd != confirm) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match.')),
        );
        return;
      }
      if (pwd.length < 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password must be at least 4 characters.')),
        );
        return;
      }
    }

    final gid = _genderId;
    final cid = _cityId;
    if (gid == null || cid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select gender and city.')),
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
        isActive: _isActive,
        password: pwd.isEmpty ? null : pwd,
        roleIds: _roleIds.toList(),
        picture: _pictureUpdated ? _pictureBase64 : null,
      );

      await ref.read(usersApiProvider).usersIdPut(
            widget.userId,
            userUpsertRequest: req,
          );

      final me = ref.read(currentUserProvider);
      if (me?.id == widget.userId) {
        final fresh =
            await ref.read(usersApiProvider).usersIdGet(widget.userId);
        ref.read(currentUserProvider.notifier).state = fresh;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User saved.')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget? _buildPicturePreview() {
    final raw = _pictureBase64;
    if (raw == null || raw.isEmpty) return null;
    try {
      final bytes = base64Decode(raw);
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          bytes,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    } catch (_) {
      return const Text('Could not decode image.');
    }
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
          u != null ? 'Edit user #${u.id}' : 'Edit user',
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
                        FilledButton(
                          onPressed: _load,
                          child: const Text('Retry'),
                        ),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 8),
                                      Text('Id: ${u.id}'),
                                      Text('Created: ${_formatDate(u.createdAt)}'),
                                      Text('Last login: ${_formatDate(u.lastLoginAt)}'),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
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
                                              icon: const Icon(Icons.photo_library_outlined),
                                              label: const Text('Pick image'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      TextField(
                                        controller: _firstName,
                                        decoration: const InputDecoration(
                                          labelText: 'First name',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      TextField(
                                        controller: _lastName,
                                        decoration: const InputDecoration(
                                          labelText: 'Last name',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      TextField(
                                        controller: _email,
                                        decoration: const InputDecoration(
                                          labelText: 'Email',
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.emailAddress,
                                      ),
                                      const SizedBox(height: 12),
                                      TextField(
                                        controller: _username,
                                        decoration: const InputDecoration(
                                          labelText: 'Username',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      TextField(
                                        controller: _phone,
                                        decoration: const InputDecoration(
                                          labelText: 'Phone',
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.phone,
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
                                        onChanged: (v) =>
                                            setState(() => _cityId = v),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: _roles
                                            .where((r) => r.id != null)
                                            .map(
                                              (r) {
                                                final id = r.id!;
                                                final selected =
                                                    _roleIds.contains(id);
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
                                              },
                                            )
                                            .toList(),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'New password (optional)',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 8),
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
    );
  }
}
