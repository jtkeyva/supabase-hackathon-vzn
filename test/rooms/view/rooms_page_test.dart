// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:vzn/rooms/rooms.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RoomsPage', () {
    group('route', () {
      test('is routable', () {
        expect(RoomsPage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders RoomsView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: RoomsPage()));
      expect(find.byType(RoomsView), findsOneWidget);
    });
  });
}
