import 'package:my_app/screens/challenge/challenge_view.dart';
import 'package:my_app/screens/challenge/challenge_viewmodel.dart';
import 'package:my_app/screens/home/home_view.dart';
import 'package:my_app/screens/home/home_viewmodel.dart';
import 'package:my_app/screens/image_picker/imagepicker_view.dart';
import 'package:my_app/screens/leaderboard/leaderboard_view.dart';
import 'package:my_app/screens/profile/profile_view.dart';
import 'package:my_app/screens/settings/settings_view.dart';
import 'package:my_app/screens/startup/startup_view.dart';
import 'package:my_app/services/authentication_service.dart';
import 'package:my_app/services/api_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: ChallengeView),
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: ImagePickerView),
    MaterialRoute(page: LeaderBoardView)
  ],
  dependencies: [
    // Lazy singletons
    LazySingleton(classType: AuthenticationService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: ApiService),
    LazySingleton(classType: ChallengeViewModel),
    LazySingleton(classType: HomeViewModel),
  ],
)
class AppSetup {}
