import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final client = Supabase.instance.client;

class RealTimeStream extends StatefulWidget {
  const RealTimeStream({Key? key}) : super(key: key);

  @override
  State<RealTimeStream> createState() => _RealTimeStreamState();
}

class _RealTimeStreamState extends State<RealTimeStream> {
  // Persisting the future as local variable to prevent refetching upon rebuilds.
  final _stream = client.from('countries').stream(['id']).execute();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        return Text('_stream');
        // return your widget with the data from snapshot
      },
    );
  }
}
