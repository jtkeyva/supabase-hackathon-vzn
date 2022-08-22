import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'rooms_state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  RoomsCubit() : super(const RoomsInitial());

  /// A description for yourCustomFunction
  FutureOr<void> init() {
    getRooms();
  }

  Future<void> getRooms() async {
    try {
      final response = await Supabase.instance.client.from('rooms').select();
      // final data = response.data as List<dynamic>;
      // print(data.toString());
      final data = response as List;
      print(response);
      // emit(RoomListSuccess(List response));
    } on Exception catch (e) {
      print('error: $e');
    }
  }
}
