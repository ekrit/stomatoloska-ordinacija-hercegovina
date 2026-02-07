import 'package:flutter/material.dart';
import 'package:soh_api/api.dart';

class DoctorHomePage extends StatelessWidget {
  const DoctorHomePage({super.key, required this.user});

  final UserResponse user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor'),
      ),
      body: Center(
        child: Text('Welcome, Dr. ${user.lastName ?? ''}'.trim()),
      ),
    );
  }
}
