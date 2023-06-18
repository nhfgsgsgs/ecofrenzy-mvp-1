import 'package:my_app/app/app.locator.dart';
import 'package:my_app/models/challenge.dart';
import 'package:my_app/services/api_service.dart';
import 'package:stacked/stacked.dart';

class ChallengeViewModel extends FutureViewModel<List<Challenge>> {
  final ApiService _challengeService = locator<ApiService>();

  List<Challenge> _challenges = [];
  List<Challenge> get challenges => _challenges;

  bool get hasPickedChallenge => _challenges
      .any((challenge) => challenge.status == ChallengeStatus.picked);

  @override
  Future<List<Challenge>> futureToRun() => _fetchChallenges();

  Future<List<Challenge>> _fetchChallenges() async {
    _challenges = await _challengeService.getChallenges();
    return _challenges;
  }

  void updateChallengeStatus(String id) async {
    await _challengeService.updateChallengeStatus(id);
    _challenges.firstWhere((challenge) => challenge.id == id).status =
        ChallengeStatus.picked;
    notifyListeners();
  }
}
