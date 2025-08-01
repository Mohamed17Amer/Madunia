import 'package:go_router/go_router.dart';
import 'package:madunia/core/utils/router/app_screens.dart';
import 'package:madunia/features/app/presentation/pages/starting_screen.dart';
import 'package:madunia/features/debit_report/presentation/view/pages/debit_screen.dart';
import 'package:madunia/features/home/presentation/view/pages/home_screen.dart';


abstract class AppRouter {
  static final router = GoRouter(
    routes: [
    /*
      GoRoute(
        path: AppScreens.onboarding,
        builder: (context, state) {
          return Container();
        },
      ),
*/

GoRoute(
        path: AppScreens.startingScreen,
        builder: (context, state) {
          return StartingScreen();
        },
      ),

      GoRoute(
        path: AppScreens.homeScreen,
        builder: (context, state) {
          return HomeScreen();
        },
      ),

      GoRoute(path: AppScreens.debitScreen,
      builder: (context, state) {
        return DebitScreen();
      },
      )
    ],
  );
}
