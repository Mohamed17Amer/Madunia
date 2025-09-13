import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia/core/utils/widgets/custom_scaffold.dart';
import 'package:madunia/features/app/data/models/app_user_model.dart';
import 'package:madunia/features/owned_report/presentation/view/widgets/add_owned_item_screen_widgets/add_new_owned_item_screen_body.dart';
import 'package:madunia/features/owned_report/presentation/view_model/cubits/owned_report_cubit/owned_report_cubit.dart';
import 'package:madunia/features/user_details/presentation/view_model/cubit/user_details_cubit.dart';

class AddOwnedItemScreen extends StatelessWidget {
  final AppUser? user;
  const AddOwnedItemScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OwnedReportCubit()),
        BlocProvider(
          create: (context) => UserDetailsCubit(),
        ),
      ],
      child: BlocBuilder<OwnedReportCubit, OwnedReportState>(
        builder: (context, state) {
          return CustomScaffold(body: AddNewOwnedItemScreenBody(user: user!));
        },
      ),
    );
  }
}
