// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:vzn/home/home.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeBody', () {
    testWidgets('renders Text', (tester) async { 
      await tester.pumpWidget(
        BlocProvider(
          create: (context) => HomeCubit(),
          child: MaterialApp(home: HomeBody()),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });
  });
}
