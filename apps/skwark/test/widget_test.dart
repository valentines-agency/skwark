// This is a basic test file to verify the Flutter test setup
// More comprehensive tests should be added as the app develops

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skwark/main.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SkwarkApp());

    // Verify that the app renders without throwing an exception
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  group('Basic widget tests', () {
    test('SkwarkApp is defined', () {
      expect(SkwarkApp, isNotNull);
    });
  });
}
