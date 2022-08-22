import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vzn/models/message.dart';
import 'package:vzn/models/profile.dart';
import 'package:vzn/models/room.dart';
import 'package:vzn/room/widgets/add_video_dialog.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../youtube_player/model/youtube_video_model.dart';
import '../widgets/chat_bubble.dart';

class RoomPageFull extends StatefulWidget {
  const RoomPageFull({
    Key? key,
    required this.room,
  }) : super(key: key);

  final Room room;

  @override
  State<RoomPageFull> createState() => _RoomPageFullState();
}

class _RoomPageFullState extends State<RoomPageFull> {
  List<Message>? _messages;
  List<YoutubeVideo>? _youtubeVideos;
  List<String>? _theList;
  final Map<String, Profile> _profileCache = {};
  StreamSubscription<List<Message>>? _messagesListener;
  StreamSubscription<List<YoutubeVideo>>? _videosListener;

  List<String> fred = [];

  late YoutubePlayerController _youtubePlayerController;
  // final _youtubePlayerController = YoutubePlayerController(
  //   params: YoutubePlayerParams(
  //     mute: false,
  //     showControls: true,
  //     showFullscreenButton: true,
  //   ),
  // );
  @override
  void initState() {
    initAwait();
    // super.initState();
    // initPlayer();
  }

  Future<void> initAwait() async {
    await initListeners();
    await initPlayer();
  }

  Future<void> initListeners() async {
    _messagesListener = Supabase.instance.client
        .from('messages:room_id=eq.${widget.room.id}')
        .stream(['id'])
        .order('created_at')
        .execute()
        .map((maps) => maps.map(Message.fromMap).toList())
        .listen(
          (messages) {
            setState(() {
              _messages = messages;
            });
            for (final message in messages) {
              _fetchProfile(message.profileId);
            }
          },
        );

    _videosListener = Supabase.instance.client
        .from('room_youtube_video:room_id=eq.${widget.room.id}')
        .stream(['id'])
        .order('created_at')
        .execute()
        .map((maps) => maps.map(YoutubeVideo.fromMap).toList())
        .listen((videos) {
          setState(() {
            _youtubeVideos = videos;
            print('videos: $videos');
            _theList = videos.cast<String>();
          });
          for (final video in videos) {
            print(video.youtubeVideo);
            fred.add(video.youtubeVideo);
          }
          print('fred: $fred');
        });
  }

  Future<void> initPlayer() async {
    _youtubePlayerController = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: false,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    )
      ..onInit = () {
        print('fredrickyyy: $fred');
        var somelist = [
          'roger',
          'gary',
          'X3FJePrGZb8',
          'Jv0qjWsXgP8',
          'uc1tzwP8GHo',
          'CRkfqH1r714',
          'L9L0gVzOLds',
          'kYfNvmF0Bqw',
        ];
        print(somelist);
        _youtubePlayerController.loadPlaylist(
          // list: [
          //   'CAOp_7s183U',
          //   'fVwQgqVdFo8',
          //   'X3FJePrGZb8',
          //   'Jv0qjWsXgP8',
          //   'uc1tzwP8GHo',
          //   'CRkfqH1r714',
          //   'L9L0gVzOLds',
          //   'kYfNvmF0Bqw',
          // ],
          list: fred,
          listType: ListType.playlist,
          startSeconds: 0,
        );
      }
      ..onFullscreenChange = (isFullScreen) {
        log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
      };
  }

  Future<void> _fetchProfile(String userId) async {
    if (_profileCache.containsKey(userId)) {
      return;
    }
    final data = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    // final data = response.data;
    if (data != null) {
      setState(() {
        _profileCache[userId] = Profile.fromMap(data);
      });
    }
  }

  Widget _messageList() {
    if (_messages == null) {
      return Center(
        child: const CircularProgressIndicator(),
      );
    }
    if (_messages!.isEmpty) {
      return Image.network(
        'https://i.giphy.com/media/DRYU7xgNIJbzQjOOBH/giphy-downsized-large.gif',
        fit: BoxFit.cover,
      );
    }

    final userId = Supabase.instance.client.auth.currentUser?.id;

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
      child: ListView.builder(
        scrollDirection: Axis.vertical,
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
    );
  }

  @override
  void dispose() {
    _messagesListener?.cancel();
    _videosListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageStream = Supabase.instance.client
        .from('rooms:id=eq.${widget.room.id}')
        .stream(['id'])
        .execute()
        .map((maps) => maps.map(Room.fromMap));

    return YoutubePlayerControllerProvider(
      controller: _youtubePlayerController,
      child: PointerInterceptor(
        child: YoutubePlayerScaffold(
          controller: _youtubePlayerController,
          aspectRatio: 16 / 9,
          builder: (context, player) {
            return Stack(children: [
              // Container(
              //   height: double.infinity,
              //   color: Colors.greenAccent[500],
              // ),
              Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.black.withOpacity(0.2),
                  elevation: 0,
                  title: Text(widget.room.name),
                  actions: [
                    YoutubeValueBuilder(
                      controller:
                          _youtubePlayerController, // This can be omitted, if using `YoutubePlayerControllerProvider`
                      builder: (context, value) {
                        final currentUserId =
                            Supabase.instance.client.auth.currentUser?.id;
                        if (widget.room.createdBy == currentUserId) {
                          return Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.add_circle),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AddVideoDialog(
                                            roomId: widget.room.id,
                                          );
                                        });
                                  }),
                              IconButton(
                                icon: const Icon(Icons.skip_previous),
                                onPressed: context.ytController.previousVideo,
                              ),
                              IconButton(
                                icon: Icon(
                                  value.playerState == PlayerState.playing
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                                onPressed: () {
                                  value.playerState == PlayerState.playing
                                      ? context.ytController.pauseVideo()
                                      : context.ytController.playVideo();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.skip_next),
                                onPressed: context.ytController.nextVideo,
                              ),
                            ],
                          );
                        }
                        return IconButton(
                            onPressed: (() {}), icon: Icon(Icons.volume_off));
                      },
                    )
                  ],
                ),
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    if (kIsWeb && constraints.maxWidth > 750) {
                      child:
                      Stack(
                        children: [
                          player,
                          PointerInterceptor(
                            child: Column(
                              children: [
                                Expanded(
                                  child: _messageList(),
                                ),
                                ChatForm(
                                  roomId: widget.room.id,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 20,
                            color: Colors.cyanAccent,
                          )
                        ],
                      );
                    }
                    return Stack(
                      children: [
                        player,
                        PointerInterceptor(
                          child: Column(
                            children: [
                              Expanded(
                                child: _messageList(),
                              ),
                              ChatForm(
                                roomId: widget.room.id,
                              ),
                              // Container(
                              //   height: 100,
                              //   color: Colors.amber,
                              // )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ]);
          },
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
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Message',
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: Colors.white60,
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
