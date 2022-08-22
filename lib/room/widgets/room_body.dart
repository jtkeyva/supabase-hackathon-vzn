import 'package:flutter/material.dart';
import 'package:vzn/room/cubit/cubit.dart';

/// {@template room_body}
/// Body of the RoomPage.
///
/// Add what it does
/// {@endtemplate}
class RoomBody extends StatelessWidget {
  /// {@macro room_body}
  const RoomBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomState>(
      builder: (context, state) {
        return Center(child: Text(state.customProperty));
      },
    );
  }
}
