import 'package:my_app/app/app.locator.dart';
import 'package:my_app/screens/challenge/challenge_viewmodel.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends IndexTrackingViewModel {
  final ChallengeViewModel _challengeViewModel = locator<ChallengeViewModel>();

  bool get hasPickedChallenge => _challengeViewModel.hasPickedChallenge;
}
