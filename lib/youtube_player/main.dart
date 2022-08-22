// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vzn/youtube_player/model/youtube_video_model.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'widgets/meta_data_section.dart';
import 'widgets/play_pause_button_bar.dart';
import 'widgets/player_state_section.dart';
import 'widgets/source_input_section.dart';
import 'widgets/volume_slider.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(YoutubeApp());
// }

///
class YoutubeAppMinimal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Player IFrame Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.cyan,
        scaffoldBackgroundColor: Colors.black45,
      ),
      debugShowCheckedModeBanner: false,
      home: YoutubeAppDemo(),
    );
  }
}

final client = Supabase.instance.client;

///
class YoutubeAppDemo extends StatefulWidget {
  @override
  _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
}

class _YoutubeAppDemoState extends State<YoutubeAppDemo> {
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
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.close();
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
