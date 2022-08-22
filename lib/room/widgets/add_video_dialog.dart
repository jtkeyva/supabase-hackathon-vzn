import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddVideoDialog extends StatelessWidget {
  AddVideoDialog({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  final String roomId;
  final _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Add Youtube Video'),
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _urlController,
              ),
            ),
            TextButton(
                onPressed: () async {
                  final currentUser =
                      Supabase.instance.client.auth.currentUser?.id;
                  final res = await Supabase.instance.client
                      .from('room_youtube_video')
                      .insert({
                    'youtube_video': _urlController.text,
                    'profile_id': currentUser,
                    'room_id': roomId,
                  })
                      // .eq('room_id', roomId)
                      .execute();
                  Navigator.of(context).pop();
                },
                child: const Text('Save'))
          ],
        ),
      ],
    );
  }
}
