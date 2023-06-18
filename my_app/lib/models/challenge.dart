enum ChallengeCategory {
  energy,
  transport,
  comsumption,
  waste,
  forestry,
  awareness
}

extension ChallengeCategoryExtension on ChallengeCategory {
  String get name {
    switch (this) {
      case ChallengeCategory.energy:
        return 'Energy and Resources';
      case ChallengeCategory.transport:
        return 'Transportation';
      case ChallengeCategory.comsumption:
        return 'Consumption';
      case ChallengeCategory.waste:
        return 'Waste Management';
      case ChallengeCategory.forestry:
        return 'Forestry';
      case ChallengeCategory.awareness:
        return 'Awareness and Innovation';
      default:
        return 'Other';
    }
  }
}

enum ChallengeStatus { start, picked, pending, done }

class Challenge {
  final String id;
  final String name;
  final String description;
  final ChallengeCategory category;
  final String impact;
  ChallengeStatus status;
  bool isDone;

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
      category: _categoryFromString(json['category']),
      impact: json['impact'],
      status: _statusFromString(json['status']),
      isDone: json['isDone'],
    );
  }

  static ChallengeCategory _categoryFromString(String category) {
    return ChallengeCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == category.toLowerCase(),
      orElse: () => throw ArgumentError('Unknown category $category'),
    );
  }

  static ChallengeStatus _statusFromString(String status) {
    return ChallengeStatus.values.firstWhere(
      (e) =>
          e.toString().toLowerCase() == 'challengestatus.$status'.toLowerCase(),
      orElse: () => throw ArgumentError('Unknown status $status'),
    );
  }
}
