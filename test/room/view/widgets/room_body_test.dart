// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:vzn/room/room.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RoomBody', () {
    testWidgets('renders Text', (tester) async { 
      await tester.pumpWidget(
        BlocProvider(
          create: (context) => RoomCubit(),
          child: MaterialApp(home: RoomBody()),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });
  });
}
