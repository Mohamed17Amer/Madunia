import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia/core/utils/widgets/custom_scaffold.dart';
import 'package:madunia/features/app/data/models/app_user_model.dart';
import 'package:madunia/features/app/presentation/view_model/cubit/app_cubit.dart';
import 'package:madunia/features/debit_report/presentation/view/widgets/debit_screen_body.dart';
import 'package:madunia/features/debit_report/presentation/view_model/cubits/debit_report_cubit/debit_report_cubit.dart';

class DebitScreen extends StatefulWidget {
  const DebitScreen({super.key});

  @override
  State<DebitScreen> createState() => _DebitScreenState();
}

class _DebitScreenState extends State<DebitScreen> {
  late AppUser user;
late String userId;

  @override
  void initState() {
    super.initState();
    user = (context).read<AppCubit>().user;
    userId = (context).read<AppCubit>().user.id;

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DebitReportCubit()..getAllDebitItems(userId:userId),

      child: CustomScaffold(body: DebitScreenBody()),
    );
  }
}
