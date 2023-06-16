import 'package:flutter/foundation.dart';
import '../models/challenge.dart';
import '../service/challenge_service.dart';

class ChallengeModel extends ChangeNotifier {
  final ChallengeService _challengeService = ChallengeService();
  late Future<List<Challenge>> futureChallenges;

  ChallengeModel() {
    _challengeService.fetchChallenges();
  }

  fetchChallenges() {
    futureChallenges = _challengeService.fetchChallenges();
    notifyListeners(); // Notify all the listeners about this change.
  }
}
