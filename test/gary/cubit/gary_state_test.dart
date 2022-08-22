// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:vzn/gary/cubit/cubit.dart';

void main() {
  group('GaryState', () {
    test('supports value equality', () {
      expect(
        GaryState(),
        equals(
          const GaryState(),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          const GaryState(),
          isNotNull,
        );
      });
    });

    group('copyWith', () {
      test(
        'copies correctly '
        'when no argument specified',
        () {
          const garyState = GaryState(
            customProperty: 'My property',
          );
          expect(
            garyState.copyWith(),
            equals(garyState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          const garyState = GaryState(
            customProperty: 'My property',
          );
          final otherGaryState = GaryState(
            customProperty: 'My property 2',
          );
          expect(garyState, isNot(equals(otherGaryState)));

          expect(
            garyState.copyWith(
              customProperty: otherGaryState.customProperty,
            ),
            equals(otherGaryState),
          );
        },
      );
    });
  });
}
