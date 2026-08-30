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

  // --- Status codebooks -------------------------------------------------
  // Reference data maintained by administration. Served through this
  // hand-written client because the generated OpenAPI package predates the
  // endpoints; regenerating it will supersede these.

  Future<List<StatusTypeItem>> listStatusTypes(String resource) async {
    final resp = await _client.invokeAPI(
      '/$resource',
      'GET',
      <QueryParam>[QueryParam('pageSize', '100')],
      null,
      <String, String>{},
      <String, String>{},
      null,
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw ApiException(resp.statusCode, resp.body);
    }
    final decoded = jsonDecode(utf8.decode(resp.bodyBytes));
    final items = decoded is Map ? decoded['items'] : decoded;
    if (items is! List) return const [];
    return items
        .whereType<Map<String, dynamic>>()
        .map(StatusTypeItem.fromJson)
        .toList();
  }

  Future<void> saveStatusType(
    String resource, {
    required int id,
    required String name,
    String? description,
    required bool isNew,
  }) async {
    final body = jsonEncode({'id': id, 'name': name, 'description': description});
    final resp = await _client.invokeAPI(
      isNew ? '/$resource' : '/$resource/$id',
      isNew ? 'POST' : 'PUT',
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

  Future<void> deleteStatusType(String resource, int id) async {
    final resp = await _client.invokeAPI(
      '/$resource/$id',
      'DELETE',
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
}

/// One row of a status codebook.
class StatusTypeItem {
  StatusTypeItem({required this.id, required this.name, this.description});

  final int id;
  final String name;
  final String? description;

  static StatusTypeItem fromJson(Map<String, dynamic> j) {
    final id = j['id'] ?? j['Id'];
    return StatusTypeItem(
      id: id is int ? id : int.tryParse('$id') ?? 0,
      name: (j['name'] ?? j['Name']) as String? ?? '',
      description: (j['description'] ?? j['Description']) as String?,
    );
  }
}

