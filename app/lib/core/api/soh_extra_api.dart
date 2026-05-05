import 'dart:convert';
import 'dart:typed_data';

import 'package:soh_api/api.dart';

/// Calls routes not yet present in the generated OpenAPI client.
class SohExtraApi {
  SohExtraApi(this._client);

  final ApiClient _client;

  Future<List<RecommendedProductItem>> fetchRecommendations({int take = 8}) async {
    final resp = await _client.invokeAPI(
      r'/Recommendation/products',
      'GET',
      <QueryParam>[QueryParam('take', '$take')],
      null,
      <String, String>{},
      <String, String>{},
      null,
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Recommendations failed (${resp.statusCode}): ${resp.body}');
    }
    final decoded = jsonDecode(utf8.decode(resp.bodyBytes));
    if (decoded is! List) {
      return const [];
    }
    return decoded
        .map((e) => RecommendedProductItem.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<void> trackProductInteraction({required int productId, String kind = 'View'}) async {
    final body = jsonEncode({'productId': productId, 'kind': kind});
    final resp = await _client.invokeAPI(
      r'/Recommendation/track',
      'POST',
      <QueryParam>[],
      body,
      <String, String>{},
      <String, String>{},
      'application/json',
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Track failed (${resp.statusCode}): ${resp.body}');
    }
  }

  Future<List<UserNotificationItem>> fetchNotifications({int take = 30}) async {
    final resp = await _client.invokeAPI(
      r'/notifications',
      'GET',
      <QueryParam>[QueryParam('take', '$take')],
      null,
      <String, String>{},
      <String, String>{},
      null,
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Notifications failed (${resp.statusCode}): ${resp.body}');
    }
    final decoded = jsonDecode(utf8.decode(resp.bodyBytes));
    if (decoded is! List) {
      return const [];
    }
    return decoded
        .map((e) => UserNotificationItem.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<void> markNotificationRead(int id) async {
    final resp = await _client.invokeAPI(
      r'/notifications/$id/read',
      'PATCH',
      <QueryParam>[],
      null,
      <String, String>{},
      <String, String>{},
      null,
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Mark read failed (${resp.statusCode}): ${resp.body}');
    }
  }

  Future<int> unreadNotificationCount() async {
    final resp = await _client.invokeAPI(
      r'/notifications/unread-count',
      'GET',
      <QueryParam>[],
      null,
      <String, String>{},
      <String, String>{},
      null,
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Unread count failed (${resp.statusCode}): ${resp.body}');
    }
    final v = jsonDecode(utf8.decode(resp.bodyBytes));
    if (v is int) return v;
    if (v is num) return v.toInt();
    return 0;
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

class UserNotificationItem {
  UserNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
  });

  final int id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  static UserNotificationItem fromJson(Map<String, dynamic> j) {
    return UserNotificationItem(
      id: (j['id'] as num).toInt(),
      title: j['title'] as String? ?? '',
      body: j['body'] as String? ?? '',
      createdAt: DateTime.tryParse(j['createdAt'] as String? ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      isRead: j['isRead'] as bool? ?? false,
    );
  }
}

class RecommendedProductItem {
  RecommendedProductItem({
    required this.product,
    required this.reasons,
    required this.score,
  });

  final ProductResponse product;
  final List<String> reasons;
  final double score;

  static RecommendedProductItem fromJson(Map<String, dynamic> j) {
    final productMap = j['product'];
    final product = productMap is Map
        ? ProductResponse.fromJson(productMap.cast<String, dynamic>()) ?? ProductResponse()
        : ProductResponse();
    final reasonsRaw = j['reasons'];
    final reasons = reasonsRaw is List ? reasonsRaw.map((e) => '$e').toList() : <String>[];
    final scoreRaw = j['score'];
    final score = scoreRaw is num ? scoreRaw.toDouble() : 0.0;
    return RecommendedProductItem(product: product, reasons: reasons, score: score);
  }
}
