// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:vzn/rooms/rooms.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RoomsBody', () {
    testWidgets('renders Text', (tester) async { 
      await tester.pumpWidget(
        BlocProvider(
          create: (context) => RoomsCubit(),
          child: MaterialApp(home: RoomsBody()),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });
  });
}
