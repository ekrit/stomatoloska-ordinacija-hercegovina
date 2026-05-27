import 'dart:convert';

import 'package:soh_api/api.dart';

/// Best-effort conversion of an exception thrown by the OpenAPI client (or
/// anything else) into a human-readable single-line message suitable for
/// snackbars and inline form error labels.
///
/// The backend's `ExceptionFilter` shapes errors as
/// `{ "errors": { "businessError": ["..."], "userError": ["..."], ... } }`.
/// This helper extracts the first non-empty entry across the known keys
/// (`businessError`, `userError`, `notFound`, `validationError`) so a 400
/// response surfaces the business message instead of "ApiException 400:
/// {\"errors\":...}" or a stack trace.
///
/// Returns [fallback] when nothing better could be extracted (e.g. network
/// timeout, malformed JSON, transient TLS error).
String extractApiErrorMessage(
  Object error, {
  String fallback = 'Something went wrong. Please try again.',
}) {
  if (error is ApiException) {
    final fromBody = _messageFromBody(error.message);
    if (fromBody != null && fromBody.isNotEmpty) {
      return fromBody;
    }
    final code = error.code;
    if (code == 401) return 'Please sign in again to continue.';
    if (code == 403) return 'You are not allowed to perform this action.';
    if (code == 404) return 'We could not find what you were looking for.';
    if (code >= 500 && code < 600) {
      return 'The server is having trouble right now. Please try again shortly.';
    }
    if (error.message != null && error.message!.isNotEmpty) {
      return error.message!;
    }
  }
  return fallback;
}

String? _messageFromBody(String? body) {
  if (body == null || body.isEmpty) return null;
  try {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final errors = decoded['errors'];
      if (errors is Map<String, dynamic>) {
        for (final key in const ['businessError', 'userError', 'notFound', 'validationError', 'ERROR']) {
          final entry = errors[key];
          final msg = _firstNonEmpty(entry);
          if (msg != null) return msg;
        }
        for (final entry in errors.values) {
          final msg = _firstNonEmpty(entry);
          if (msg != null) return msg;
        }
      }
      final flat = decoded['message'] ?? decoded['title'];
      if (flat is String && flat.isNotEmpty) return flat;
    }
  } catch (_) {
    // body is not JSON; fall through to other heuristics
  }
  if (body.length < 200 && !body.startsWith('{')) {
    return body;
  }
  return null;
}

String? _firstNonEmpty(Object? entry) {
  if (entry is String && entry.isNotEmpty) return entry;
  if (entry is List) {
    for (final item in entry) {
      if (item is String && item.isNotEmpty) return item;
    }
  }
  return null;
}
