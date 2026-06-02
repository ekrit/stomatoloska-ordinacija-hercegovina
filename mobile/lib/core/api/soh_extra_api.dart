import 'dart:convert';

import 'package:http/http.dart' show Response;
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
    Future<Response> invoke(String method, Object? body, String? contentType) {
      return _client.invokeAPI(
        r'/notifications/$id/read',
        method,
        <QueryParam>[],
        body,
        const {'Cache-Control': 'no-store'},
        <String, String>{},
        contentType,
      );
    }

    var resp = await invoke('POST', <String, dynamic>{}, 'application/json');
    if (resp.statusCode >= 200 && resp.statusCode < 300) return;

    // Some stacks route POST differently; retry on 404 only.
    if (resp.statusCode == 404) {
      resp = await invoke('PATCH', <String, dynamic>{}, 'application/json');
      if (resp.statusCode >= 200 && resp.statusCode < 300) return;
      resp = await invoke('GET', null, null);
      if (resp.statusCode >= 200 && resp.statusCode < 300) return;
    }

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Mark read failed (${resp.statusCode}): ${resp.body}');
    }
  }

  /// Creates a PayPal order for the appointment. The server reads the price
  /// from the service catalog; the client never sends an amount.
  Future<PaymentOrderInfo> createPaymentOrder(int appointmentId) async {
    final body = jsonEncode({'appointmentId': appointmentId});
    final resp = await _client.invokeAPI(
      r'/Payment/orders',
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
    final j = jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
    return PaymentOrderInfo.fromJson(j);
  }

  /// Captures (finalizes) the PayPal order tied to a payment. Idempotent.
  Future<bool> capturePayment(int paymentId) async {
    final resp = await _client.invokeAPI(
      '/Payment/orders/$paymentId/capture',
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
    final j = jsonDecode(utf8.decode(resp.bodyBytes));
    if (j is Map && (j['isPaid'] == true || j['IsPaid'] == true)) return true;
    return false;
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
    final readAtRaw = j['readAt'] ?? j['ReadAt'];
    final hasReadAt = readAtRaw != null &&
        ((readAtRaw is String && readAtRaw.isNotEmpty) ||
            readAtRaw is DateTime);
    final explicitRead = _parseBool(j['isRead'] ?? j['IsRead']);
    final isRead = explicitRead ?? hasReadAt;
    final idVal = j['id'] ?? j['Id'];
    final titleVal = j['title'] ?? j['Title'];
    final bodyVal = j['body'] ?? j['Body'];
    final createdVal = j['createdAt'] ?? j['CreatedAt'];
    return UserNotificationItem(
      id: _parseNotificationId(idVal),
      title: titleVal as String? ?? '',
      body: bodyVal as String? ?? '',
      createdAt: DateTime.tryParse(createdVal as String? ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      isRead: isRead,
    );
  }

  static int _parseNotificationId(dynamic idVal) {
    if (idVal == null) {
      throw const FormatException('notification id missing');
    }
    if (idVal is int) return idVal;
    if (idVal is num) return idVal.toInt();
    if (idVal is String) return int.parse(idVal.trim());
    throw FormatException('notification id', idVal);
  }

  static bool? _parseBool(dynamic v) {
    if (v == null) return null;
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      final s = v.toLowerCase();
      if (s == 'true' || s == '1') return true;
      if (s == 'false' || s == '0') return false;
    }
    return null;
  }
}

class PaymentOrderInfo {
  PaymentOrderInfo({
    required this.paymentId,
    required this.orderId,
    required this.approvalUrl,
    required this.amount,
  });

  final int paymentId;
  final String orderId;
  final String approvalUrl;
  final double amount;

  static PaymentOrderInfo fromJson(Map<String, dynamic> j) {
    final paymentId = j['paymentId'] ?? j['PaymentId'];
    final orderId = j['orderId'] ?? j['OrderId'];
    final approvalUrl = j['approvalUrl'] ?? j['ApprovalUrl'];
    final amount = j['amount'] ?? j['Amount'];
    return PaymentOrderInfo(
      paymentId: paymentId is int ? paymentId : int.parse('$paymentId'),
      orderId: orderId as String? ?? '',
      approvalUrl: approvalUrl as String? ?? '',
      amount: amount is num ? amount.toDouble() : double.tryParse('$amount') ?? 0,
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
