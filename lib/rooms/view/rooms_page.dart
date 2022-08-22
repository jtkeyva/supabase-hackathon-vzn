import 'package:flutter/material.dart';
import 'package:vzn/rooms/cubit/cubit.dart';
import 'package:vzn/rooms/widgets/rooms_body.dart';

/// {@template rooms_page}
/// A description for RoomsPage
/// {@endtemplate}
class RoomsPage extends StatelessWidget {
  /// {@macro rooms_page}
  const RoomsPage({Key? key}) : super(key: key);

  /// The static route for RoomsPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const RoomsPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomsCubit()..init(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rooms'),
          actions: [
            IconButton(
              onPressed: (() {}),
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: RoomsView(),
      ),
    );
  }
}

/// {@template rooms_view}
/// Displays the Body of RoomsView
/// {@endtemplate}
class RoomsView extends StatelessWidget {
  /// {@macro rooms_view}
  const RoomsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RoomsBody();
  }
}
