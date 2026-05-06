import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_providers.dart';
import '../../../core/api/soh_extra_api.dart';

final recommendedProductsProvider = FutureProvider.autoDispose<List<RecommendedProductItem>>((ref) async {
  final api = SohExtraApi(ref.watch(apiClientProvider));
  return api.fetchRecommendations(take: 12);
});
