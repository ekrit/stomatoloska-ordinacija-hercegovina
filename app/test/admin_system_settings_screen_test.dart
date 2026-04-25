import 'package:app/features/admin_dashboard/presentation/widgets/quick_actions_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Quick action opens system settings screen', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: QuickActionsCard()),
        ),
      ),
    );

    await tester.tap(find.text('System Settings'));
    await tester.pumpAndSettle();

    expect(find.text('System settings'), findsOneWidget);
  });
}
