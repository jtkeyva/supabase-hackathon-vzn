// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:vzn/gary/gary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GaryPage', () {
    group('route', () {
      test('is routable', () {
        expect(GaryPage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders GaryView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: GaryPage()));
      expect(find.byType(GaryView), findsOneWidget);
    });
  });
}
