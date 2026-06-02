import 'dart:convert';
import 'dart:typed_data';

import 'package:soh_api/api.dart';

/// Calls routes not yet present in the generated OpenAPI client.
class SohExtraApi {
  SohExtraApi(this._client);

  final ApiClient _client;

  /// Changes the signed-in user's password after verifying the current one.
  Future<void> changePassword(int userId, String oldPassword, String newPassword) async {
    final body = jsonEncode({'oldPassword': oldPassword, 'newPassword': newPassword});
    final resp = await _client.invokeAPI(
      '/Users/$userId/change-password',
      'POST',
      <QueryParam>[],
      body,
      <String, String>{},
      <String, String>{},
      'application/json',
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw ApiException(resp.statusCode, resp.body);
    }
  }

  /// Refunds a paid payment (only allowed while the appointment is not completed).
  Future<void> refundPayment(int paymentId) async {
    final resp = await _client.invokeAPI(
      '/Payment/$paymentId/refund',
      'POST',
      <QueryParam>[],
      null,
      <String, String>{},
      <String, String>{},
      null,
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw ApiException(resp.statusCode, resp.body);
    }
  }

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
