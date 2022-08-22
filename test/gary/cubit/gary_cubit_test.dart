// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vzn/gary/cubit/cubit.dart';

void main() {
  group('GaryCubit', () {
    group('constructor', () {
      test('can be instantiated', () {
        expect(
          GaryCubit(),
          isNotNull,
        );
      });
    });

    test('initial state has default value for customProperty', () {
      final garyCubit = GaryCubit();
      expect(garyCubit.state.customProperty, equals('Default Value'));
    });

    blocTest<GaryCubit, GaryState>(
      'yourCustomFunction emits nothing',
      build: GaryCubit.new,
      act: (cubit) => cubit.yourCustomFunction(),
      expect: () => <GaryState>[],
    );
  });
}
