class YoutubeVideo {
  final String roomYoutubeVideoId;
  final DateTime createdAt;
  final String profileId;
  final String roomId;
  final String youtubeVideo;

  YoutubeVideo({
    required this.roomYoutubeVideoId,
    required this.createdAt,
    required this.profileId,
    required this.roomId,
    required this.youtubeVideo,
  });

  YoutubeVideo.fromMap(Map<String, dynamic> map)
      : roomYoutubeVideoId = map['room_youtube_video_id'],
        createdAt = DateTime.parse(map['created_at']),
        profileId = map['profile_id'] ?? 'Untitled',
        roomId = map['room_id'] ?? 'Untitled',
        youtubeVideo = map['youtube_video'] ?? 'Untitled';
}
