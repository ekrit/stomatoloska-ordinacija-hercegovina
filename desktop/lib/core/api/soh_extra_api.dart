import 'dart:typed_data';

import 'package:soh_api/api.dart';

/// Calls routes not yet present in the generated OpenAPI client.
class SohExtraApi {
  SohExtraApi(this._client);

  final ApiClient _client;

  /// Server-side logout — revokes this JWT so it cannot be reused.
  Future<void> logout() async {
    final resp = await _client.invokeAPI(
      r'/Users/logout',
      'POST',
      <QueryParam>[],
      null,
      <String, String>{},
      <String, String>{},
      null,
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Logout failed (${resp.statusCode}): ${resp.body}');
    }
  }

  Future<Uint8List> downloadAppointmentsSummaryPdf({DateTime? fromUtc, DateTime? toUtc}) async {
    final qp = <QueryParam>[];
    if (fromUtc != null) {
      qp.add(QueryParam('fromUtc', fromUtc.toUtc().toIso8601String()));
    }
    if (toUtc != null) {
      qp.add(QueryParam('toUtc', toUtc.toUtc().toIso8601String()));
    }
    final resp = await _client.invokeAPI(
      r'/report/pdf/appointments-summary',
      'GET',
      qp,
      null,
      <String, String>{},
      <String, String>{},
      null,
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('PDF download failed (${resp.statusCode}): ${resp.body}');
    }
    return resp.bodyBytes;
  }

  Future<Uint8List> downloadRevenueByServicePdf({int months = 6}) async {
    final resp = await _client.invokeAPI(
      r'/report/pdf/revenue-by-service',
      'GET',
      <QueryParam>[QueryParam('months', '$months')],
      null,
      <String, String>{},
      <String, String>{},
      null,
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('PDF download failed (${resp.statusCode}): ${resp.body}');
    }
    return resp.bodyBytes;
  }
}
