import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vzn/models/room.dart';
import 'package:vzn/room/view/room_page.dart';
import 'package:vzn/room/view/room_page_full.dart';
import 'package:vzn/rooms/cubit/cubit.dart';

/// {@template rooms_body}
/// Body of the RoomsPage.
///
/// Add what it does
/// {@endtemplate}
class RoomsBody extends StatelessWidget {
  /// {@macro rooms_body}
  const RoomsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomsCubit, RoomsState>(
      builder: (context, state) {
        return Stack(
          children: [
            StreamBuilder<List<Room>>(
              stream: Supabase.instance.client
                  .from('rooms')
                  .stream(['id'])
                  .order('created_at')
                  .execute()
                  .map((maps) => maps.map(Room.fromMap).toList()),
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final rooms = snapshot.data!;
                print(rooms);
                if (rooms.isEmpty) {
                  return Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          'https://i.giphy.com/media/26hkhPJ5hmdD87HYA/giphy.webp',
                          fit: BoxFit.cover,
                          // height: double.infinity,
                          // width: double.infinity,
                          // alignment: Alignment.center,
                        ),
                      ),
                      const Center(child: Text('No rooms')),
                    ],
                  );
                }

                return ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return RoomPageFull(room: room);
                          }),
                        );
                      },
                      title: Text(room.name + room.createdBy),
                    );
                  },
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
