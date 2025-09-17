import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia/core/helper/helper_funcs.dart';
import 'package:madunia/core/utils/router/app_screens.dart';
import 'package:madunia/core/utils/widgets/custom_scaffold.dart';
import 'package:madunia/features/app/presentation/view_model/cubit/app_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if (state is CheckIsLoggedSuccess) {
            navigateReplacementWithGoRouter(
              context: context,
              path: AppScreens.startingScreen,
              extra: state.currentUser,
            );
          } else {
            navigateReplacementWithGoRouter(
              context: context,
              path: AppScreens.authScreen,
            );
          }
        },
        builder: (context, state) {
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
