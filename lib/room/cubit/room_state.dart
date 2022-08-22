part of 'room_cubit.dart';

/// {@template room}
/// RoomState description
/// {@endtemplate}
class RoomState extends Equatable {
  /// {@macro room}
  const RoomState({
    this.customProperty = 'Default Value',
  });

  /// A description for customProperty
  final String customProperty;

  @override
  List<Object> get props => [customProperty];

  /// Creates a copy of the current RoomState with property changes
  RoomState copyWith({
    String? customProperty,
  }) {
    return RoomState(
      customProperty: customProperty ?? this.customProperty,
    );
  }
}
/// {@template room_initial}
/// The initial state of RoomState
/// {@endtemplate}
class RoomInitial extends RoomState {
  /// {@macro room_initial}
  const RoomInitial() : super();
}
