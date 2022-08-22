import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:vzn/models/message.dart';
import 'package:vzn/models/profile.dart';
import 'package:vzn/models/room.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:vzn/youtube_player/main.dart';
import 'package:vzn/youtube_player/widgets/meta_data_section.dart';
import 'package:vzn/youtube_player/widgets/play_pause_button_bar.dart';
import 'package:vzn/youtube_player/widgets/player_state_section.dart';
import 'package:vzn/youtube_player/widgets/source_input_section.dart';
import 'package:vzn/youtube_player/widgets/volume_slider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({
    Key? key,
    required this.room,
  }) : super(key: key);

  final Room room;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  List<Message>? _messages;

  final Map<String, Profile> _profileCache = {};

  StreamSubscription<List<Message>>? _messagesListener;

  late YoutubePlayerController _controller;
  late List<String> VideoList = [
    'CAOp_7s183U',
    'bHDt5lb1cUU',
    'X3FJePrGZb8',
    'Jv0qjWsXgP8',
    'uc1tzwP8GHo',
    'CRkfqH1r714',
    'L9L0gVzOLds',
    'kYfNvmF0Bqw',
  ];

  @override
  void initState() {
    _messagesListener = Supabase.instance.client
        .from('messages:room_id=eq.${widget.room.id}')
        .stream(['id'])
        .order('created_at')
        .execute()
        .map((maps) => maps.map(Message.fromMap).toList())
        .listen((messages) {
          setState(() {
            _messages = messages;
          });
          for (final message in messages) {
            _fetchProfile(message.profileId);
          }
        });
    super.initState();
    // VideoList.shuffle();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        autoPlay: true,
      ),
    )
      ..onInit = () {
        // final _stream = client
        //     .from('room_youtube_video')
        //     .stream(['room_youtube_video_id'])
        //     .order('created_at')
        //     .execute()
        //     .map((maps) => maps.map(YoutubeVideo.fromMap).toList());

        // print('cmon man');
        // print(_stream.toString());
        // final List mylist = _stream as List;
        // print(mylist[0]);

        // final calculationStream =
        //     _stream.map<String>((event) => 'Square: ${event}');
        // calculationStream.forEach(print);

        // print('v v v v v v v v videos: $_stream');
        _controller.loadPlaylist(
          list: VideoList,
          listType: ListType.playlist,
          startSeconds: 0,
        );
      }
      ..onFullscreenChange = (isFullScreen) {
        log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
      };
  }

  @override
  void dispose() {
    _controller.close();
    _messagesListener?.cancel();
    super.dispose();
  }

  Future<void> _fetchProfile(String userId) async {
    if (_profileCache.containsKey(userId)) {
      return;
    }
    final res = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single()
        .execute();
    final data = res.data;
    if (data != null) {
      setState(() {
        _profileCache[userId] = Profile.fromMap(data);
      });
    }
  }

  Widget _messageList() {
    if (_messages == null) {
      return const Center(
        child: Text('Loading...'),
      );
    }
    if (_messages!.isEmpty) {
      return const Center(
        child: Text('No one has started talking yet...'),
      );
    }
    // final userId = Supabase.instance.client.auth.user()?.id;
    final userId = Supabase.instance.client.auth.currentUser?.id;

    //   return ShaderMask(
    //     shaderCallback: (Rect rect) {
    //       return LinearGradient(
    //         begin: Alignment.topCenter,
    //         end: Alignment.bottomCenter,
    //         colors: [
    //           Colors.purple,
    //           Colors.transparent,
    //           Colors.transparent,
    //           Colors.purple
    //         ],
    //         stops: [
    //           0.0,
    //           0.1,
    //           0.9,
    //           1.0
    //         ], // 10% purple, 80% transparent, 10% purple
    //       ).createShader(rect);
    //     },
    //     blendMode: BlendMode.dstOut,
    //     child: ListView.builder(
    //       scrollDirection: Axis.horizontal,
    //       // padding: const EdgeInsets.symmetric(
    //       //   horizontal: 12,
    //       //   vertical: 8,
    //       // ),
    //       padding: const EdgeInsets.fromLTRB(12, 8, 52, 22),
    //       reverse: true,
    //       itemCount: _messages!.length,
    //       itemBuilder: ((context, index) {
    //         final message = _messages![index];
    //         return Align(
    //           alignment: userId == message.profileId
    //               ? Alignment.centerRight
    //               : Alignment.centerLeft,
    //           child: Padding(
    //             padding: const EdgeInsets.symmetric(vertical: 8),
    //             child: ChatBubble(
    //               userId: userId,
    //               message: message,
    //               profileCache: _profileCache,
    //             ),
    //           ),
    //         );
    //       }),
    //     ),
    //   );
    // }
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.purple,
            Colors.transparent,
            Colors.transparent,
            Colors.purple
          ],
          stops: [
            0.0,
            0.1,
            0.9,
            1.0
          ], // 10% purple, 80% transparent, 10% purple
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              // padding: const EdgeInsets.symmetric(
              //   horizontal: 12,
              //   vertical: 8,
              // ),
              padding: const EdgeInsets.fromLTRB(12, 8, 52, 0),
              reverse: true,
              itemCount: _messages!.length,
              itemBuilder: ((context, index) {
                final message = _messages![index];
                return Align(
                  alignment: userId == message.profileId
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ChatBubble(
                      userId: userId,
                      message: message,
                      profileCache: _profileCache,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stream = Supabase.instance.client
        .from('rooms:id=eq.${widget.room.id}')
        .stream(['id'])
        // .order('created_at')
        .execute()
        // .map((maps) => maps.map(Room.fromMap).toList()),
        .map((maps) => maps.map(Room.fromMap));
    // .toList();
    // final roomx = stream.map<String>((event) => 'Square: ${event}');
    // print(roomx.toList());
    // roomx.forEach(print);
    print(stream);
    // final rooms = stream.snapshot.data;

    return Stack(
      children: [
        Container(
          height: double.infinity,
          color: Colors.cyan,
        ),
        // YoutubeAppMinimal(),
        YoutubePlayerScaffold(
          controller: _controller,
          builder: (context, player) {
            return Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: _messageList(),
                    ),
                    ChatForm(
                      roomId: widget.room.id,
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (kIsWeb && constraints.maxWidth > 750) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: player),
                              // const Expanded(
                              //   flex: 2,
                              //   child: SingleChildScrollView(
                              //     child: Controls(),
                              //   ),
                              // ),
                            ],
                          );
                        }

                        return ListView(
                          children: [
                            player,
                            const Controls(),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: StreamBuilder<Object>(
                    stream: stream,

                    // Supabase.instance.client
                    //     .from('rooms:id=eq.${widget.room.id}')
                    //     .stream(['id'])
                    //     // .order('created_at')
                    //     .execute()
                    //     // .map((maps) => maps.map(Room.fromMap).toList()),
                    //     .map((maps) => maps.map(Room.fromMap)),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text('loading...'),
                        );
                      }
                      final rooms = snapshot.data!;
                      final roomstring = rooms.toString();
                      print('rooms! $roomstring');
                      // final room = rooms[0];
                      // final blather = json.encode(rooms);
                      // print(blather);
                      // final Map washburn = json.decode(blather);
                      // print('washy $washburn');
                      // final _map = List<Map<String, dynamic>>.from(jsonDecode(rooms.body));

                      // if (rooms.isEmpty) {
                      //   return const Center(
                      //     child: Text('Create a room'),
                      //   );
                      // }
                      return TextButton(
                        child: Text(
                          widget.room.name,
                          // rooms.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return EditTitleDialog(
                                  roomId: widget.room.id,
                                );
                              });
                        },
                      );
                    }),
                actions: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return InviteDialog(roomId: widget.room.id);
                          });
                    },
                    child: const Text('Invite'),
                  ),
                  PlayPauseButtonBar(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.speaker),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.play_circle),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.play_circle),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class EditTitleDialog extends StatelessWidget {
  EditTitleDialog({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  final String roomId;
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Change Room Title'),
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _titleController,
              ),
            ),
            TextButton(
                onPressed: () async {
                  final res = await Supabase.instance.client
                      .from('rooms')
                      .update({
                        'name': _titleController.text,
                      })
                      .eq('id', roomId)
                      .execute();
                  Navigator.of(context).pop();
                },
                child: const Text('Save'))
          ],
        ),
      ],
    );
  }
}

class InviteDialog extends StatefulWidget {
  const InviteDialog({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  final String roomId;

  @override
  State<InviteDialog> createState() => _InviteDialogState();
}

class _InviteDialogState extends State<InviteDialog> {
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Invite a user'),
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _textController,
              ),
            ),
            TextButton(
              onPressed: () async {
                final username = _textController.text;
                final res = await Supabase.instance.client
                    .from('profiles')
                    .select()
                    .eq('username', username)
                    .single()
                    .execute();
                final data = res.data;
                final insertRes = await Supabase.instance.client
                    .from('room_participants')
                    .insert({
                  'room_id': widget.roomId,
                  'profile_id': data['id'],
                }).execute();
                Navigator.of(context).pop();
              },
              child: const Text('Invite'),
            ),
          ],
        ),
      ],
    );
  }
}

// class ChatBubble extends StatelessWidget {
//   const ChatBubble({
//     Key? key,
//     required this.userId,
//     required this.message,
//     required this.profileCache,
//   }) : super(key: key);

//   final String? userId;
//   final Message message;
//   final Map<String, Profile> profileCache;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       elevation: 4,
//       borderRadius: BorderRadius.circular(20),
//       // color: userId == message.profileId ? Colors.grey[300] : Colors.blue[200],
//       color: userId == message.profileId
//           ? Colors.black.withOpacity(0.3)
//           : Colors.blue[200],

//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               profileCache[message.profileId]?.username ?? 'loading...',
//               style: const TextStyle(
//                 // color: Colors.black54,
//                 color: Colors.white60,
//                 fontSize: 14,
//               ),
//             ),
//             Text(
//               message.content,
//               style: const TextStyle(
//                   // color: Colors.black,
//                   color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.userId,
    required this.message,
    required this.profileCache,
  }) : super(key: key);

  final String? userId;
  final Message message;
  final Map<String, Profile> profileCache;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(20),
      // color: userId == message.profileId ? Colors.grey[300] : Colors.blue[200],
      color: userId == message.profileId
          ? Colors.black.withOpacity(0.3)
          : Colors.blue[200],

      child: Container(
        height: 100,
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profileCache[message.profileId]?.username ?? 'loading...',
                style: const TextStyle(
                  // color: Colors.black54,
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
              Text(
                message.content,
                style: const TextStyle(
                    // color: Colors.black,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatForm extends StatefulWidget {
  const ChatForm({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  final String roomId;

  @override
  State<ChatForm> createState() => _ChatFormState();
}

class _ChatFormState extends State<ChatForm> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late FocusNode myFocusNode;

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: TextFormField(
                  autofocus: true,
                  onFieldSubmitted: (value) async {
                    print('ENTER pressed');

                    // Will trigger validation for ALL fields in Form.
                    // All your TextFormFields (email, password) share
                    // the SAME Form and thus the SAME _formKey.

                    if (_formKey.currentState!.validate()) {
                      print('ALL FIELDS ARE VALID, GO ON ...');
                    }
                    // final text = _textController.text;
                    // if (text.isEmpty) {
                    //   return;
                    // }
                    // _textController.clear();
                    // final res =
                    //     await Supabase.instance.client.from('messages').insert({
                    //   'room_id': widget.roomId,
                    //   // 'profile_id': Supabase.instance.client.auth.user()?.id,
                    //   'profile_id':
                    //       Supabase.instance.client.auth.currentUser?.id,
                    //   'content': text,
                    // }).execute();
                    sendOnPressed();
                  },
                  controller: _textController,
                  // decoration: InputDecoration(
                  //   hintText: 'Type something',
                  //   fillColor: Colors.white,
                  //   filled: true,
                  //   border: OutlineInputBorder(
                  //     borderRadius: BorderRadius.circular(30.0),
                  //   ),
                  // ),
                  style: TextStyle(color: Colors.white),
                  cursorRadius: const Radius.circular(20.0),
                  decoration: InputDecoration(
                    fillColor: Colors.white10,
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send_outlined),
                      onPressed: sendOnPressed,
                      // size: 20,
                      color: Colors.grey.shade300,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      // borderSide: BorderSide.none,
                    ),
                    hintText: 'Message',
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: Colors.white60,
                    ),
                    focusColor: Colors.orange,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                  ),
                ),
              ),
            ),
            // TextButton(
            //   onPressed: sendOnPressed,
            //   child: const Text('Send'),
            // ),
          ],
        ),
      ),
    );
  }

  void sendOnPressed() async {
    final text = _textController.text;
    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    final res = await Supabase.instance.client.from('messages').insert({
      'room_id': widget.roomId,
      // 'profile_id': Supabase.instance.client.auth.user()?.id,
      'profile_id': Supabase.instance.client.auth.currentUser?.id,
      'content': text,
    }).execute();

    // final error = res.error;
    // if (error != null && mounted) {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text(error.message)));
    // }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

///
class Controls extends StatelessWidget {
  ///
  const Controls();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _space,
          MetaDataSection(),
          _space,
          SourceInputSection(),
          _space,
          PlayPauseButtonBar(),
          _space,
          VolumeSlider(),
          _space,
          PlayerStateSection(),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}
