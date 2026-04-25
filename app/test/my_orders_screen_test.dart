import 'package:app/features/patient/presentation/screens/my_orders_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('orderAmountLabel formats amount', () {
    expect(orderAmountLabel(12), '12.00 KM');
    expect(orderAmountLabel(9.5), '9.50 KM');
  });
}
