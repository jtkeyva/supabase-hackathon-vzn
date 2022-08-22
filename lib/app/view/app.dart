// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:vzn/chat_room/chat_room_page.dart';
import 'package:vzn/chat_room/chat_room_page_old.dart';
import 'package:vzn/chat_room/youtube_player_hooktest.dart';
import 'package:vzn/counter/counter.dart';
import 'package:vzn/home/view/home_page.dart';
import 'package:vzn/l10n/l10n.dart';
import 'package:vzn/models/room.dart';
import 'package:vzn/rooms/view/rooms_page.dart';
import 'package:vzn/roomz/roomz.dart';
import 'package:vzn/sandbox/youtube/youtube_player_iframe/main.dart';

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      // home: const CounterPage(),
    );
  }

  final GoRouter _router = GoRouter(routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/counter',
      builder: (context, state) => CounterPage(),
    ),
    GoRoute(
      path: '/youtube',
      builder: (context, state) => YoutubeApp(),
    ),
    GoRoute(
      path: '/roomlist',
      builder: (context, state) => RoomsPage(),
    ),
    GoRoute(
      path: '/roomz',
      builder: (context, state) => RoomzPage(),
    ),
  ]);
}
