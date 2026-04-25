import 'package:app/features/admin_dashboard/presentation/widgets/recent_activity_section.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('activityCountLabel formats total activity count', () {
    expect(activityCountLabel(0), 'Ukupno: 0');
    expect(activityCountLabel(7), 'Ukupno: 7');
  });
}
