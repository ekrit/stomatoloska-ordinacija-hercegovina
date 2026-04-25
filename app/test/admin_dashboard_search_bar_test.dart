import 'package:app/features/admin_dashboard/presentation/widgets/admin_dashboard_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AdminDashboardSearchBar submits search navigation', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: AdminDashboardSearchBar(width: 320),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'testquery');
    await tester.tap(find.byTooltip('Search'));
    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.textContaining('testquery'), findsWidgets);
  });
}
