class Member {
  const Member({
    required this.id,
    required this.gymId,
    required this.name,
    required this.email,
  });

  final String id;
  final String gymId;
  final String name;
  final String email;

  String get firstName {
    final parts = name.trim().split(' ');
    return parts.isEmpty ? name : parts.first;
  }
}
