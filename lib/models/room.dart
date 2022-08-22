class Room {
  final String id;
  final String name;
  final DateTime createdAt;
  final String createdBy;

  Room({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.createdBy,
  });

  Room.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'] ?? 'Untitled',
        createdAt = DateTime.parse(map['created_at']),
        createdBy = map['created_by'] ?? '';
}
