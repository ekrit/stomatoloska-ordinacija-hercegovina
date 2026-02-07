import 'package:flutter/material.dart';
import 'package:soh_api/api.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key, required this.user});

  final UserResponse user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
      ),
      body: Center(
        child: Text('Welcome, ${user.username ?? 'admin'}'),
      ),
    );
  }
}
