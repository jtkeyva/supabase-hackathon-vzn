import 'package:flutter/material.dart';
import 'package:vzn/gary/cubit/cubit.dart';
import 'package:vzn/gary/widgets/gary_body.dart';

/// {@template gary_page}
/// A description for GaryPage
/// {@endtemplate}
class GaryPage extends StatelessWidget {
  /// {@macro gary_page}
  const GaryPage({Key? key}) : super(key: key);

  /// The static route for GaryPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const GaryPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GaryCubit(),
      child: const Scaffold(
        body: GaryView(),
      ),
    );
  }    
}

/// {@template gary_view}
/// Displays the Body of GaryView
/// {@endtemplate}
class GaryView extends StatelessWidget {
  /// {@macro gary_view}
  const GaryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GaryBody();
  }
}
