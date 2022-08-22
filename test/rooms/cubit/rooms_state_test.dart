// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:vzn/rooms/cubit/cubit.dart';

void main() {
  group('RoomsState', () {
    test('supports value equality', () {
      expect(
        RoomsState(),
        equals(
          const RoomsState(),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          const RoomsState(),
          isNotNull,
        );
      });
    });

    group('copyWith', () {
      test(
        'copies correctly '
        'when no argument specified',
        () {
          const roomsState = RoomsState(
            customProperty: 'My property',
          );
          expect(
            roomsState.copyWith(),
            equals(roomsState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          const roomsState = RoomsState(
            customProperty: 'My property',
          );
          final otherRoomsState = RoomsState(
            customProperty: 'My property 2',
          );
          expect(roomsState, isNot(equals(otherRoomsState)));

          expect(
            roomsState.copyWith(
              customProperty: otherRoomsState.customProperty,
            ),
            equals(otherRoomsState),
          );
        },
      );
    });
  });
}
