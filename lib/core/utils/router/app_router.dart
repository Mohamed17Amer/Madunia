import 'package:go_router/go_router.dart';
import 'package:madunia/core/utils/router/app_screens.dart';
import 'package:madunia/features/app/data/models/app_user_model.dart';
import 'package:madunia/features/app/presentation/pages/starting_screen.dart';
import 'package:madunia/features/debit_report/presentation/view/pages/debit_screen.dart';
import 'package:madunia/features/instructions/presentation/view/pages/annimated_instructions_screen.dart';
import 'package:madunia/features/repair_request/presentation/view/pages/repair_request_screen.dart';
import 'package:madunia/features/user_details/presentation/view/pages/user_details_screen.dart';

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
        path: AppScreens.userDetailsScreen,
        builder: (context, state) {
          return UserDetailsScreen();
        },
      ),

      GoRoute(
        path: AppScreens.debitScreen,
        builder: (context, state) {
          return DebitScreen();
        },
      ),

      GoRoute(
        path: AppScreens.repairRequestScreen,
        builder: (context, state) {
          return RepairRequestScreen();
        },
      ),

      GoRoute(
        path: AppScreens.animatedInstructionsScreen,
        builder: (context, state) {
          return AnimatedInstructionsScreen();
        },
      ),
    ],
  );
}
