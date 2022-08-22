import 'package:flutter/material.dart';
import 'package:vzn/gary/cubit/cubit.dart';

/// {@template gary_body}
/// Body of the GaryPage.
///
/// Add what it does
/// {@endtemplate}
class GaryBody extends StatelessWidget {
  /// {@macro gary_body}
  const GaryBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GaryCubit, GaryState>(
      builder: (context, state) {
        return Center(child: Text(state.customProperty));
      },
    );
  }
}
