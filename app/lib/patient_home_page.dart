import 'package:flutter/material.dart';
import 'package:soh_api/api.dart';

class PatientHomePage extends StatelessWidget {
  const PatientHomePage({super.key, required this.user});

  final UserResponse user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient'),
      ),
      body: Center(
        child: Text('Welcome, ${user.firstName ?? 'patient'}'),
      ),
    );
  }
}
