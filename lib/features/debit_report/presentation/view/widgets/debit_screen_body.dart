import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia/core/utils/colors/app_colors.dart';
import 'package:madunia/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia/core/utils/widgets/custom_txt.dart';
import 'package:madunia/features/app/data/models/app_user_model.dart';
import 'package:madunia/features/app/presentation/view_model/cubit/app_cubit.dart';
import 'package:madunia/features/debit_report/presentation/view/widgets/debit_sliver_list.dart';
import 'package:madunia/features/debit_report/presentation/view_model/cubits/debit_report_cubit/debit_report_cubit.dart';

class DebitScreenBody extends StatefulWidget {
  const DebitScreenBody({super.key});

  @override
  State<DebitScreenBody> createState() => _DebitScreenBodyState();
}

class _DebitScreenBodyState extends State<DebitScreenBody> {
  late AppUser user;

  @override
  void initState() {
    super.initState();
    user = (context).read<AppCubit>().user;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          ..._drawHeader(),

          BlocConsumer<DebitReportCubit, DebitReportState>(
            listener: (context, state) {},
            builder: (BuildContext context, DebitReportState state) {
              return _drawBody(context, state);
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _drawHeader() {
    return <Widget>[
      // safe area
      SliverToBoxAdapter(child: SafeArea(child: SizedBox(height: 5))),

      // app bar
      SliverToBoxAdapter(
        child: CustomAppBar(title: "كشف المديونية المستحقة عليه"),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 20)),

      // add new debit item button
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
        child: Divider(
          thickness: 2.00,
          color: AppColors.bottomNavBarSelectedItemColor,
        ),
      ),
    ];
  }

  Widget _drawBody(BuildContext context, DebitReportState state) {
    if (state is GetAllDebitItemsSuccess) {
      if (state.allUserItemDebits.isEmpty) {
        return SliverFillRemaining(
          child: Center(child: CustomTxt(title: "لم تتم إضافة عناصر بعد.")),
        );
      } else {
        return DebitSliverList(allUserItemDebits: state.allUserItemDebits);
      }
    } else if (state is GetAllDebitItemsFailure) {
      return SliverFillRemaining(child: Center(child: Text(state.errmesg)));
    } else if (state is DebitReportLoading) {
      return SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return SliverFillRemaining(child: Center(child: Text("...")));
    }
  }
}
