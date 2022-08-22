// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:vzn/room/cubit/cubit.dart';

void main() {
  group('RoomState', () {
    test('supports value equality', () {
      expect(
        RoomState(),
        equals(
          const RoomState(),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          const RoomState(),
          isNotNull,
        );
      });
    });

    group('copyWith', () {
      test(
        'copies correctly '
        'when no argument specified',
        () {
          const roomState = RoomState(
            customProperty: 'My property',
          );
          expect(
            roomState.copyWith(),
            equals(roomState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          const roomState = RoomState(
            customProperty: 'My property',
          );
          final otherRoomState = RoomState(
            customProperty: 'My property 2',
          );
          expect(roomState, isNot(equals(otherRoomState)));

          expect(
            roomState.copyWith(
              customProperty: otherRoomState.customProperty,
            ),
            equals(otherRoomState),
          );
        },
      );
    });
  });
}
