part of 'gary_cubit.dart';

/// {@template gary}
/// GaryState description
/// {@endtemplate}
class GaryState extends Equatable {
  /// {@macro gary}
  const GaryState({
    this.customProperty = 'Default Value',
  });

  /// A description for customProperty
  final String customProperty;

  @override
  List<Object> get props => [customProperty];

  /// Creates a copy of the current GaryState with property changes
  GaryState copyWith({
    String? customProperty,
  }) {
    return GaryState(
      customProperty: customProperty ?? this.customProperty,
    );
  }
}
/// {@template gary_initial}
/// The initial state of GaryState
/// {@endtemplate}
class GaryInitial extends GaryState {
  /// {@macro gary_initial}
  const GaryInitial() : super();
}
