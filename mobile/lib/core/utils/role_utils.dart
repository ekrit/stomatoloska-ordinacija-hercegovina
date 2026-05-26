import 'package:soh_api/api.dart';

bool userIsAdmin(UserResponse? user) {
  if (user?.roles == null) return false;
  for (final role in user!.roles!) {
    final n = (role.name ?? '').toLowerCase();
    if (n == 'administrator' || n == 'admin') return true;
  }
  return false;
}

bool userIsDoctor(UserResponse? user) {
  if (user?.roles == null) return false;
  for (final role in user!.roles!) {
    final n = (role.name ?? '').toLowerCase();
    if (n == 'doctor' || n == 'dentist' || n == 'stomatolog') return true;
  }
  return false;
}

bool userIsPatient(UserResponse? user) {
  if (user?.roles == null) return false;
  for (final role in user!.roles!) {
    final n = (role.name ?? '').toLowerCase();
    if (n == 'patient' || n == 'user') return true;
  }
  return false;
}
