class Challenge {
  final String id;
  final String name;
  final String description;
  final String category;
  final String status;
  final bool isDone;

  Challenge({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.status,
    required this.isDone,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      status: json['status'],
      isDone: json['isDone'],
    );
  }
}
