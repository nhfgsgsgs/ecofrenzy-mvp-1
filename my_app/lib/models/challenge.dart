class Challenge {
  final String id;
  final String name;
  final String description;
  final String category;
  final String impact;
  // final String caption;
  final String status;
  final bool isDone;

  Challenge({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.impact,
    // required this.caption,
    required this.status,
    required this.isDone,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      impact: json['impact'],
      // caption: json['caption'],
      status: json['status'],
      isDone: json['isDone'],
    );
  }
}
