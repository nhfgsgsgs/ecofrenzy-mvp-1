import 'package:my_app/screens/challenge/challenge_view.dart';
import 'package:my_app/screens/home/home_view.dart';
import 'package:my_app/screens/profile/profile_view.dart';
import 'package:my_app/screens/settings/settings_view.dart';
import 'package:my_app/screens/startup/startup_view.dart';
import 'package:my_app/services/authentication_service.dart';
import 'package:my_app/services/challenge_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: ChallengeView),
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: ProfileView)
  ],
  dependencies: [
    // Lazy singletons
    LazySingleton(classType: AuthenticationService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: ChallengeService),
  ],
)
class AppSetup {}
