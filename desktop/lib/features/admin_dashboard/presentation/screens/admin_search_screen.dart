import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/appointment_labels.dart';
import '../../../admin_users/presentation/screens/user_edit_screen.dart';

final _adminSearchProvider = FutureProvider.autoDispose
    .family<AdminSearchResults, String>((ref, query) async {
  final q = query.trim();
  if (q.isEmpty) {
    return AdminSearchResults.empty();
  }
  final usersApi = ref.watch(usersApiProvider);
  final patientApi = ref.watch(patientApiProvider);
  final appointmentApi = ref.watch(appointmentApiProvider);
  final doctorApi = ref.watch(doctorApiProvider);

  final results = await Future.wait([
    usersApi.usersGet(FTS: q, retrieveAll: true),
    patientApi.patientGet(FTS: q, retrieveAll: true),
    appointmentApi.appointmentGet(FTS: q, retrieveAll: true),
    doctorApi.doctorGet(FTS: q, retrieveAll: true),
  ]);

  return AdminSearchResults(
    users: (results[0] as UserResponsePagedResult?)?.items ?? [],
    patients: (results[1] as PatientResponsePagedResult?)?.items ?? [],
    appointments: (results[2] as AppointmentResponsePagedResult?)?.items ?? [],
    doctors: (results[3] as DoctorResponsePagedResult?)?.items ?? [],
  );
});

class AdminSearchResults {
  AdminSearchResults({
    required this.users,
    required this.patients,
    required this.appointments,
    required this.doctors,
  });

  factory AdminSearchResults.empty() => AdminSearchResults(
        users: [],
        patients: [],
        appointments: [],
        doctors: [],
      );

  final List<UserResponse> users;
  final List<PatientResponse> patients;
  final List<AppointmentResponse> appointments;
  final List<DoctorResponse> doctors;

  int get total =>
      users.length + patients.length + appointments.length + doctors.length;
}

class AdminSearchScreen extends ConsumerWidget {
  const AdminSearchScreen({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Search')),
        body: const Center(child: Text('Enter a search term in the dashboard search field.')),
      );
    }

    final async = ref.watch(_adminSearchProvider(query));
    final df = DateFormat.yMMMd();
    final tf = DateFormat.Hm();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search: $query'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (data) {
          if (data.total == 0) {
            return const Center(child: Text('No matches.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (data.users.isNotEmpty) ...[
                Text('Users', style: Theme.of(context).textTheme.titleMedium),
                ...data.users.map(
                  (u) => ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text('${u.firstName ?? ''} ${u.lastName ?? ''}'.trim()),
                    subtitle: Text(u.email ?? u.username ?? ''),
                    onTap: u.id == null
                        ? null
                        : () {
                            Navigator.of(context).push<void>(
                              MaterialPageRoute<void>(
                                builder: (_) => UserEditScreen(userId: u.id!),
                              ),
                            );
                          },
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (data.patients.isNotEmpty) ...[
                Text('Patients', style: Theme.of(context).textTheme.titleMedium),
                ...data.patients.map(
                  (p) => ListTile(
                    leading: const Icon(Icons.badge_outlined),
                    title: Text('${p.firstName ?? ''} ${p.lastName ?? ''}'.trim()),
                    subtitle: Text('User ID: ${p.userId ?? '—'}'),
                    onTap: p.userId == null
                        ? null
                        : () {
                            Navigator.of(context).push<void>(
                              MaterialPageRoute<void>(
                                builder: (_) => UserEditScreen(userId: p.userId!),
                              ),
                            );
                          },
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (data.doctors.isNotEmpty) ...[
                Text('Doctors', style: Theme.of(context).textTheme.titleMedium),
                ...data.doctors.map(
                  (d) => ListTile(
                    leading: const Icon(Icons.medical_services_outlined),
                    title: Text('${d.firstName ?? ''} ${d.lastName ?? ''}'.trim()),
                    subtitle: Text(d.specialization ?? ''),
                    onTap: d.userId == null
                        ? null
                        : () {
                            Navigator.of(context).push<void>(
                              MaterialPageRoute<void>(
                                builder: (_) => UserEditScreen(userId: d.userId!),
                              ),
                            );
                          },
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (data.appointments.isNotEmpty) ...[
                Text('Appointments', style: Theme.of(context).textTheme.titleMedium),
                ...data.appointments.map(
                  (a) {
                    final st = a.startTime;
                    final when = st != null ? '${df.format(st)} ${tf.format(st)}' : '—';
                    return ListTile(
                      leading: const Icon(Icons.event_note_outlined),
                      title: Text(when),
                      subtitle: Text(
                        'ID ${a.id ?? '—'} · ${appointmentStatusLabel(a.status)}',
                      ),
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
