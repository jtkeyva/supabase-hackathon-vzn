import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'gary_state.dart';

class GaryCubit extends Cubit<GaryState> {
  GaryCubit() : super(const GaryInitial());

  /// A description for yourCustomFunction 
  FutureOr<void> yourCustomFunction() {
    // TODO: Add Logic
  }
}
