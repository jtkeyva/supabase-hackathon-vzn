// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vzn/models/profile.dart';
import 'package:vzn/youtube_player/model/youtube_video_model.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'widgets/meta_data_section.dart';
import 'widgets/play_pause_button_bar.dart';
import 'widgets/player_state_section.dart';
import 'widgets/source_input_section.dart';
import 'widgets/volume_slider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(YoutubeApp());
// }

///
class YoutubeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Player IFrame Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: YoutubeAppDemo(),
    );
  }
}

///
class YoutubeAppDemo extends StatefulWidget {
  @override
  _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
}

class _YoutubeAppDemoState extends State<YoutubeAppDemo> {
  late YoutubePlayerController _controller;

  List<YoutubeVideo>? _youtubeVideos;
  final Map<String, Profile> _profileCache = {};
  StreamSubscription<List<YoutubeVideo>>? _videosListener;

  @override
  void initState() {
    final tempRoomId = '3bf41029-ad7b-46a0-bd48-b5bc7c5d09d1';
    _videosListener = Supabase.instance.client
        // .from('room_youtube_video:room_id=eq.${widget.room.id}')
        .from('room_youtube_video:room_id=eq.${tempRoomId}')
        .stream(['id'])
        .order('created_at', ascending: false)
        .execute()
        .map((maps) => maps.map(YoutubeVideo.fromMap).toList())
        .listen((youtubeVideos) {
          setState(() {
            _youtubeVideos = youtubeVideos;
            print('ytv: $_youtubeVideos');
            final YoutubeVideo ytvindex = _youtubeVideos![0];
            print('ytvindex: $ytvindex');
            final String ytvideo = ytvindex.youtubeVideo;
            print('ytvideo: $ytvideo ');

            if (ytvideo.startsWith('http://') ||
                ytvideo.startsWith('https://')) {
              final videoId = YoutubePlayerController.convertUrlToId(ytvideo);

              context.ytController.loadVideoById(
                videoId: videoId ?? '',
              );
            } else if (ytvideo.length != 11) {
              print('invalide source');
            }
          });
          // for (final message in messages) {
          //   _fetchProfile(message.profileId);
          // }
        });
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        autoPlay: true,
      ),
    )
      ..onInit = () {
        print('_youtubeVideos: $_youtubeVideos');
        print(_youtubeVideoList());
        _controller.loadPlaylist(
          list: [
            'Jv0qjWsXgP8',
            'uc1tzwP8GHo',
            'CRkfqH1r714',
            'L9L0gVzOLds',
            'kYfNvmF0Bqw',
          ],
          listType: ListType.playlist,
          startSeconds: 0,
        );
      }
      ..onFullscreenChange = (isFullScreen) {
        log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
      };
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (kIsWeb && constraints.maxWidth > 750) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: player),
                    const Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: Controls(),
                      ),
                    ),
                    Expanded(
                      child: _youtubeVideoList(),
                    ),
                  ],
                );
              }

              return ListView(
                children: [
                  player,
                  const Controls(),
                  _youtubeVideoList(),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.close();
    _videosListener?.cancel();
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

  Widget _youtubeVideoList() {
    if (_youtubeVideos == null) {
      return const Center(
        child: Text('Loading...'),
      );
    }
    if (_youtubeVideos!.isEmpty) {
      return const Center(
        child: Text('No one has started talking yet...'),
      );
    }
    // final userId = Supabase.instance.client.auth.user()?.id;
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
      child: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 200,
            child: ListView.builder(
              // scrollDirection: Axis.horizontal,
              // padding: const EdgeInsets.symmetric(
              //   horizontal: 12,
              //   vertical: 8,
              // ),
              padding: const EdgeInsets.fromLTRB(12, 8, 52, 0),
              reverse: true,
              itemCount: _youtubeVideos!.length,
              itemBuilder: ((context, index) {
                final video = _youtubeVideos![index];
                return Align(
                  alignment: userId == video.profileId
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ChatBubble(
                      userId: userId,
                      video: video,
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
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.userId,
    required this.video,
    required this.profileCache,
  }) : super(key: key);

  final String? userId;
  final YoutubeVideo video;
  final Map<String, Profile> profileCache;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(20),
      // color: userId == message.profileId ? Colors.grey[300] : Colors.blue[200],
      color: userId == video.profileId
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
                profileCache[video.profileId]?.username ?? 'loading...',
                style: const TextStyle(
                  // color: Colors.black54,
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
              Text(
                video.youtubeVideo,
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
