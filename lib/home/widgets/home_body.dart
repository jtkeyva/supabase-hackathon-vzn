import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vzn/home/cubit/cubit.dart';

/// {@template home_body}
/// Body of the HomePage.
///
/// Add what it does
/// {@endtemplate}
class HomeBody extends StatelessWidget {
  /// {@macro home_body}
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // return Center(child: Text(state.customProperty));
        return ListView(
          children: [
            Text(state.customProperty),
            TextButton(
              onPressed: (() => context.push('/counter')),
              child: Text('counter'),
            ),
            TextButton(
              onPressed: (() => context.push('/youtube')),
              child: Text('youtube'),
            ),
            TextButton(
              onPressed: (() => context.push('/roomlist')),
              child: Text('room list'),
            ),
            TextButton(
              onPressed: (() => context.push('/roomz')),
              child: Text('roomz'),
            ),
            TextButton(
              onPressed: (() => context.push('/ytpbg')),
              child: Text('youtube player background'),
            ),
          ],
        );
      },
    );
  }
}
