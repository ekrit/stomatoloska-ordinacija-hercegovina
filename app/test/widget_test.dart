import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  testWidgets('app boots with splash loading', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: SohApp()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
