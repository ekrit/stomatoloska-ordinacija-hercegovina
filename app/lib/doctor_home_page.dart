import 'package:flutter/material.dart';
import 'package:soh_api/api.dart';
import 'widgets/user_appbar_actions.dart';

class DoctorHomePage extends StatelessWidget {
  const DoctorHomePage({super.key, required this.user});

  final UserResponse user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor'),
        actions: buildUserAppBarActions(
          context: context,
          user: user,
          canLogout: true,
          onLogout: () => _confirmLogout(context),
        ),
      ),
      body: Center(
        child: Text('Welcome, Dr. ${user.lastName ?? ''}'.trim()),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showLogoutConfirm(context);
    if (!shouldLogout) {
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }
}
