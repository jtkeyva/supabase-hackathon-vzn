import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final client = Supabase.instance.client;

class RealTimeExample extends StatefulWidget {
  const RealTimeExample({Key? key}) : super(key: key);

  @override
  State<RealTimeExample> createState() => _RealTimeExampleState();
}

class _RealTimeExampleState extends State<RealTimeExample> {
  late final RealtimeSubscription _subscription;
  @override
  void initState() {
    _subscription =
        client.from('countries').on(SupabaseEventTypes.all, (payload) {
      // Do something when there is an update
    }).subscribe();
    super.initState();
  }

  @override
  void dispose() {
    client.removeSubscription(_subscription);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('RealTimeExample'),
      ],
    );
  }
}
