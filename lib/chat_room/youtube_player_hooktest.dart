import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayHookTest extends HookWidget {
  YouTubePlayHookTest({Key? key}) : super(key: key);

  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  final List<String> _ids = [
    'nPt8bK2gbaU',
    'gQDByCdjUXw',
    'iLnmTe5Q2Qw',
    '_WoCV4c6XOE',
    'KmzdUe0RSJo',
    '6jZDSSZZxjQ',
    'p2lYr3vM_1w',
    '7QUtEmBT_-w',
    '34_PXCzGw1M',
  ];

  @override
  Widget build(BuildContext context) {
// YoutubePlayerController _controller = YoutubePlayerController(
//     initialVideoId: 'iLnmTe5Q2Qw',
//     flags: YoutubePlayerFlags(
//         autoPlay: true,
//         mute: true,
//     ),
// );

    _controller = YoutubePlayerController(
      initialVideoId: 'iLnmTe5Q2Qw',
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;

    YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.blueAccent,
      topActions: <Widget>[
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            _controller.metadata.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
            size: 25.0,
          ),
          onPressed: () {
            log('Settings Tapped!');
          },
        ),
      ],
      onReady: () {
        _isPlayerReady = true;
      },
      onEnded: (data) {
        _controller.load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
        // _showSnackBar('Next Video Started!');
      },
    );

    return Container();
  }

  void listener() {
    // if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
    //   setState(() {
    //     _playerState = _controller.value.playerState;
    //     _videoMetaData = _controller.metadata;
    //   });
    // }
  }
  //   void _showSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         message,
  //         textAlign: TextAlign.center,
  //         style: const TextStyle(
  //           fontWeight: FontWeight.w300,
  //           fontSize: 16.0,
  //         ),
  //       ),
  //       backgroundColor: Colors.blueAccent,
  //       behavior: SnackBarBehavior.floating,
  //       elevation: 1.0,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(50.0),
  //       ),
  //     ),
  //   );
  // }
}
