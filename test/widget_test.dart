// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tile_fusion_2048/main.dart';

void main() {
  testWidgets('Tile Fusion 2048 app loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Game2048App());

    // Verify that the app title is displayed.
    expect(find.text('Tile Fusion 2048'), findsOneWidget);

    // Verify that score displays are present.
    expect(find.text('SCORE'), findsOneWidget);
    expect(find.text('HIGH SCORE'), findsOneWidget);

    // Verify that New Game button is present.
    expect(find.text('New Game'), findsOneWidget);
  });
}
