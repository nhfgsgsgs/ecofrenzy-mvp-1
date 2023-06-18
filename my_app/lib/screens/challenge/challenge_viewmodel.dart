import 'package:my_app/app/app.locator.dart';
import 'package:my_app/models/challenge.dart';
import 'package:my_app/services/challenge_service.dart';
import 'package:stacked/stacked.dart';

class ChallengeViewModel extends FutureViewModel<List<Challenge>> {
  final ChallengeService _challengeService = locator<ChallengeService>();

  List<Challenge> _challenges = [];
  List<Challenge> get challenges => _challenges;

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
