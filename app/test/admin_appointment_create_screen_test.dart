import 'package:app/features/admin_dashboard/presentation/screens/admin_appointment_create_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parseIdInput parses integer IDs', () {
    expect(parseIdInput('14'), 14);
    expect(parseIdInput(' 25 '), 25);
    expect(parseIdInput('abc'), isNull);
  });
}
