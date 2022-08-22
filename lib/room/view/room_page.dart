import 'package:flutter/material.dart';
import 'package:vzn/models/room.dart';
import 'package:vzn/room/cubit/cubit.dart';
import 'package:vzn/room/widgets/room_body.dart';

/// {@template room_page}
/// A description for RoomPage
/// {@endtemplate}
class RoomPage extends StatelessWidget {
  /// {@macro room_page}
  const RoomPage({Key? key, required Room room}) : super(key: key);

  /// The static route for RoomPage
  // static Route<dynamic> route() {
  //   return MaterialPageRoute<dynamic>(builder: (_) => const RoomPage(room: null,));
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rooms'),
          actions: [
            IconButton(
              onPressed: (() {}),
              icon: Icon(Icons.play_circle),
            ),
            IconButton(
              onPressed: (() {}),
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: RoomView(),
      ),
    );
  }
}

/// {@template room_view}
/// Displays the Body of RoomView
/// {@endtemplate}
class RoomView extends StatelessWidget {
  /// {@macro room_view}
  const RoomView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RoomBody();
  }
}
