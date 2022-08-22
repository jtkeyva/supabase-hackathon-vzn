// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vzn/room/cubit/cubit.dart';

void main() {
  group('RoomCubit', () {
    group('constructor', () {
      test('can be instantiated', () {
        expect(
          RoomCubit(),
          isNotNull,
        );
      });
    });

    test('initial state has default value for customProperty', () {
      final roomCubit = RoomCubit();
      expect(roomCubit.state.customProperty, equals('Default Value'));
    });

    blocTest<RoomCubit, RoomState>(
      'yourCustomFunction emits nothing',
      build: RoomCubit.new,
      act: (cubit) => cubit.yourCustomFunction(),
      expect: () => <RoomState>[],
    );
  });
}
