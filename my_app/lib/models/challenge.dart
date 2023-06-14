class Challenge {
  final String id;
  final String name;
  final String description;
  final String status;
  final bool isDone;

  Challenge({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.isDone,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      isDone: json['isDone'],
    );
  }
}
