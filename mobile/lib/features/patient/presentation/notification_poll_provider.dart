import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_providers.dart';
import '../../../core/api/soh_extra_api.dart';

/// Periodic unread count for auto-refresh (complements SignalR on the server).
final notificationUnreadPollProvider = StreamProvider.autoDispose<int>((ref) async* {
  final api = SohExtraApi(ref.watch(apiClientProvider));
  while (true) {
    try {
      yield await api.unreadNotificationCount();
    } catch (_) {
      yield 0;
    }
    await Future<void>.delayed(const Duration(seconds: 45));
  }
});
