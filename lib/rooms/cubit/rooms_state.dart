part of 'rooms_cubit.dart';

/// {@template rooms}
/// RoomsState description
/// {@endtemplate}
class RoomsState {
  /// {@macro rooms}
  const RoomsState({
    this.customProperty = 'Default Value',
  });

  /// A description for customProperty
  final String customProperty;

  /// Creates a copy of the current RoomsState with property changes
  RoomsState copyWith({
    String? customProperty,
  }) {
    return RoomsState(
      customProperty: customProperty ?? this.customProperty,
    );
  }
}

/// {@template rooms_initial}
/// The initial state of RoomsState
/// {@endtemplate}
class RoomsInitial extends RoomsState {
  /// {@macro rooms_initial}
  const RoomsInitial() : super();
}

// class RoomsSuccess extends RoomsState {
//   /// {@macro rooms_initial}
//   const RoomsSuccess({
//     final List
//     this.rooms = ["hello","what"],
//   }) : super();
//   final List rooms;
// }