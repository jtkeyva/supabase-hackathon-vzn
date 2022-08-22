// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:vzn/room/room.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RoomPage', () {
    group('route', () {
      test('is routable', () {
        expect(RoomPage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders RoomView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: RoomPage()));
      expect(find.byType(RoomView), findsOneWidget);
    });
  });
}
