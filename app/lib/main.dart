import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';
import 'core/api/api_providers.dart';
import 'core/config/app_config.dart';
import 'features/admin_dashboard/presentation/screens/admin_dashboard_screen.dart';
import 'widgets/user_appbar_actions.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  static const _defaultGenderId = 1;
  static const _defaultCityId = 3;
  final _usernameController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _bearerAuth = HttpBearerAuth();
  late final ApiClient _apiClient;
  late final UsersApi _usersApi;

  bool _isLoading = false;
  String? _error;
  AuthResponse? _authResponse;
  int? _userCount;
  bool _showPassword = false;

  bool get _isDesktop {
    if (kIsWeb) {
      return false;
    }
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient(basePath: AppConfig.apiBaseUrl, authentication: _bearerAuth);
    _usersApi = UsersApi(_apiClient);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _userCount = null;
    });

    try {
      final response = await _usersApi.usersAuthenticatePost(
        userLoginRequest: UserLoginRequest(
          username: _usernameController.text.trim(),
          password: _loginPasswordController.text,
        ),
      );

      if (response?.token == null || response!.token!.isEmpty) {
        setState(() {
          _error = 'Login succeeded but no token was returned.';
          _authResponse = null;
        });
        return;
      }

      _bearerAuth.accessToken = response.token!;
      ref.read(authTokenProvider.notifier).state = response.token!;
      final users = await _usersApi.usersGet(retrieveAll: true);

      setState(() {
        _authResponse = response;
        _userCount = users?.totalCount ?? users?.items?.length;
      });

      await _navigateAfterLogin(response.user);
    } catch (error) {
      setState(() {
        _error = error.toString();
        _authResponse = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _openRegistration() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RegistrationPage(
          usersApi: _usersApi,
          defaultGenderId: _defaultGenderId,
          defaultCityId: _defaultCityId,
        ),
      ),
    );
  }

  void _logout() {
    setState(() {
      _bearerAuth.accessToken = '';
      _authResponse = null;
      _userCount = null;
      _error = null;
    });
    ref.read(authTokenProvider.notifier).state = null;
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showLogoutConfirm(context);
    if (!shouldLogout) {
      return;
    }
    _logout();
  }

  @override
  Widget build(BuildContext context) {
    final authUser = _authResponse?.user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: 420,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _loginPasswordController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Login'),
                ),
                if (!_isDesktop)
                  TextButton(
                    onPressed: _isLoading ? null : _openRegistration,
                    child: const Text('Register as patient'),
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 20,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _error ?? '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                if (_authResponse != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Logged in as ${authUser?.username ?? 'unknown'}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text('Token expires: ${_authResponse?.expiresAt ?? '-'}'),
                  const SizedBox(height: 8),
                  Text('Total users: ${_userCount ?? '-'}'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateAfterLogin(UserResponse? user) async {
    if (user == null) {
      return;
    }

    final roles = user.roles ?? [];
    final roleNames = roles
        .map((role) => (role.name ?? '').toLowerCase())
        .where((name) => name.isNotEmpty)
        .toList();

    if (roleNames.contains('administrator') || roleNames.contains('admin')) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
      );
      return;
    }

    setState(() {
      _bearerAuth.accessToken = '';
      _authResponse = null;
      _userCount = null;
      _error = 'Administrator access only.';
    });
    ref.read(authTokenProvider.notifier).state = null;
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({
    super.key,
    required this.usersApi,
    required this.defaultGenderId,
    required this.defaultCityId,
  });

  final UsersApi usersApi;
  final int defaultGenderId;
  final int defaultCityId;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}


class _RegistrationPageState extends State<RegistrationPage> {
  final _usernameController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _registerPasswordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (_registerPasswordController.text != _confirmPasswordController.text) {
        setState(() {
          _error = 'Passwords do not match.';
        });
        return;
      }

      await widget.usersApi.usersRegisterPost(
        userRegisterRequest: UserRegisterRequest(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          username: _usernameController.text.trim(),
          password: _registerPasswordController.text,
          phoneNumber: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          genderId: widget.defaultGenderId,
          cityId: widget.defaultCityId,
        ),
      );

      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
    } catch (error) {
      setState(() {
        _error = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        actions: buildUserAppBarActions(
          context: context,
          canLogout: false,
          showProfile: false,
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 420,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _registerPasswordController,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        icon: Icon(
                          _showPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_showConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _showConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Create account'),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
