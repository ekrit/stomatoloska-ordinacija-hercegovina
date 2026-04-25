import 'package:app/features/admin_dashboard/presentation/screens/admin_product_edit_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('validateProductName requires a value', () {
    expect(validateProductName(''), 'Name is required.');
    expect(validateProductName('   '), 'Name is required.');
    expect(validateProductName('Toothbrush'), isNull);
  });
}
