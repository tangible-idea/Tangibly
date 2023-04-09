// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tangibly/main.dart';

void main() {
  testWidgets('Basic First and Second screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await Firebase.initializeApp();
    await tester.pumpWidget(Tangibly());

    // Verify our starting title and button text.
    expect(find.textContaining('Study'), findsOneWidget);
    expect(find.text('Continue with your Email'), findsOneWidget);
    expect(find.textContaining('By continuing you agree'), findsOneWidget);

    // Tap the 'email' icon and lead to the next page.
    await tester.tap(find.byIcon(Icons.email));
    await tester.pump();

    // Verify that the page has changed.
    expect(find.text("What's your"), findsOneWidget);
    expect(find.text('YOUR EMAIL'), findsOneWidget);
  });
}
