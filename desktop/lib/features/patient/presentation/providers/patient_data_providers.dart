import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import 'patient_repository_providers.dart';

final medicalRecordsProvider =
    FutureProvider.autoDispose<List<MedicalRecordResponse>>((ref) async {
  return ref.watch(patientCareRepositoryProvider).listMedicalRecords();
});
