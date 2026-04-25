import 'package:app/features/patient/presentation/providers/patient_data_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soh_api/api.dart';

void main() {
  test('communityPreferredCategories returns most common categories', () {
    final products = <ProductResponse>[
      ProductResponse(id: 1, name: 'A', category: 'Toothbrush', price: 2),
      ProductResponse(id: 2, name: 'B', category: 'Toothbrush', price: 3),
      ProductResponse(id: 3, name: 'C', category: 'Mouthwash', price: 4),
    ];

    final top = communityPreferredCategories(products);
    expect(top.first, 'toothbrush');
  });
}
