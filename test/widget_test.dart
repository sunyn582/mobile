// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/utils/theme_provider.dart';

void main() {
  testWidgets('Habit Tracker app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const HabitTrackerApp(),
      ),
    );

    // Wait for animations
    await tester.pumpAndSettle();

    // Verify that welcome screen shows up
    expect(find.text('Habit Tracker'), findsOneWidget);
    expect(find.text('Build good habits,\none day at a time.'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
