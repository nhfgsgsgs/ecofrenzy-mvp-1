class Challenge {
  final String id;
  final String name;
  final String description;
  final String caption;
  final String category;
  final String impact;
  final String status;
  final bool isDone;

  Challenge({
    required this.id,
    required this.name,
    required this.description,
    required this.caption,
    required this.category,
    required this.impact,
    required this.status,
    required this.isDone,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      caption: json['caption'],
      category: json['category'],
      impact: json['impact'],
      status: json['status'],
      isDone: json['isDone'],
    );
  }
}
