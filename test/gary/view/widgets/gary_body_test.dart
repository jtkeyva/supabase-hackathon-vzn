// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:vzn/gary/gary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GaryBody', () {
    testWidgets('renders Text', (tester) async { 
      await tester.pumpWidget(
        BlocProvider(
          create: (context) => GaryCubit(),
          child: MaterialApp(home: GaryBody()),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });
  });
}
