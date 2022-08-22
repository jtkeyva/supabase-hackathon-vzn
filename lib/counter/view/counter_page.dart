// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vzn/counter/counter.dart';
import 'package:vzn/l10n/l10n.dart';
import 'package:vzn/sandbox/realtime/realtimeexample.dart';
import 'package:vzn/sandbox/youtube/youtube_player_iframe/main.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text('l10n.counterAppBarTitle haha'),
        actions: [
          IconButton(
            onPressed: () {
              final curentUser = Supabase.instance.client.auth.currentUser;
              print(curentUser?.email);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const RealTimeExample()),
              // );
            },
            icon: Icon(Icons.sailing),
          ),
          IconButton(
            onPressed: () {
              final curentUser = Supabase.instance.client.auth.currentUser;
              print(curentUser?.email);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => YoutubeApp()),
              // );
              context.push('/youtube');
            },
            icon: Icon(Icons.tv),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
          ),
          RealTimeExample(),
          const Center(child: CounterText()),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            onPressed: () => context.read<CounterCubit>().increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'decrement',
            onPressed: () => context.read<CounterCubit>().decrement(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((CounterCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.headline1);
  }
}
