// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vzn/rooms/cubit/cubit.dart';

void main() {
  group('RoomsCubit', () {
    group('constructor', () {
      test('can be instantiated', () {
        expect(
          RoomsCubit(),
          isNotNull,
        );
      });
    });

    test('initial state has default value for customProperty', () {
      final roomsCubit = RoomsCubit();
      expect(roomsCubit.state.customProperty, equals('Default Value'));
    });

    blocTest<RoomsCubit, RoomsState>(
      'yourCustomFunction emits nothing',
      build: RoomsCubit.new,
      act: (cubit) => cubit.yourCustomFunction(),
      expect: () => <RoomsState>[],
    );
  });
}
